import { SupabaseClient } from '@supabase/supabase-js';
import {
  NotFoundError,
  InternalError,
  ConflictError,
  ForbiddenError,
  ValidationError,
} from '../../lib/errors';
import type {
  Fine,
  FineVote,
  FineWithVotes,
  Punishment,
  Transaction,
  CreateFineInput,
  VoteInput,
  AppealInput,
} from './types';
import {
  calculateVotingEndTime,
  processVoteResults,
  canVoteOnFine,
  shouldAutoResolve,
  calculateFineAmount,
  determineFineStatus,
} from './utils';
import { sendNotificationToPack, sendNotificationToUser } from '../notifications/services';
import { NotificationType } from '../notifications/types';

/**
 * Create a new fine
 */
export async function createFine(
  supabase: SupabaseClient,
  packId: string,
  creatorId: string,
  input: CreateFineInput
): Promise<Fine> {
  // Get goal and pack details (RLS allows pack members to read goals)
  const { data: goal } = await supabase
    .from('goals')
    .select('title, fine_amount, pack_id')
    .eq('id', input.goal_id)
    .single();

  if (!goal || goal.pack_id !== packId) {
    throw new NotFoundError('Goal not found in this pack');
  }

  // Calculate fine amount (use goal's fine_amount or input amount)
  const amount = input.amount || goal.fine_amount || 500; // Default 500 cents = $5

  // Calculate voting end time
  const votingEndsAt = calculateVotingEndTime();

  // Create fine (RLS allows pack members to create fines)
  const { data: fine, error } = await supabase
    .from('fines')
    .insert({
      pack_id: packId,
      user_id: input.user_id,
      goal_id: input.goal_id,
      check_in_id: input.check_in_id || null,
      amount,
      status: 'voting', // Status: voting (pack voting in progress)
      voting_ends_at: votingEndsAt.toISOString(),
    })
    .select(
      '*, user:users(username, profile_pic), goal:goals(title)'
    )
    .single();

  if (error || !fine) {
    console.error('Fine creation error:', error);
    throw new InternalError('Failed to create fine');
  }

  // Notify pack members about new fine and voting
  await sendNotificationToPack(
    supabase,
    packId,
    NotificationType.FINE_CREATED,
    {
      username: fine.user?.username || 'Someone',
      amount,
      fineId: fine.id,
      packId,
    }
  );

  return {
    ...fine,
    user: fine.user,
    goal: fine.goal,
  } as Fine;
}

/**
 * Get fine details with vote information
 */
export async function getFineWithVotes(
  supabase: SupabaseClient,
  fineId: string
): Promise<FineWithVotes> {
  // Get fine
  const { data: fine, error: fineError } = await supabase
    .from('fines')
    .select(
      '*, user:users(username, profile_pic), goal:goals(title)'
    )
    .eq('id', fineId)
    .single();

  if (fineError || !fine) {
    throw new NotFoundError('Fine');
  }

  // Get votes
  const { data: votes } = await supabase
    .from('fine_votes')
    .select('*, user:users(username)')
    .eq('fine_id', fineId)
    .order('created_at', { ascending: false });

  // Get pack member count
  const { data: pack } = await supabase
    .from('packs')
    .select('member_count')
    .eq('id', fine.pack_id)
    .single();

  // Process vote results
  const voteResult = processVoteResults(
    (votes || []).map((v) => ({
      ...v,
      user: v.user,
    })) as FineVote[],
    fine.voting_ends_at || new Date().toISOString(),
    pack?.member_count || 0
  );

  // Auto-resolve if needed
  if (shouldAutoResolve(fine)) {
    await resolveFine(supabase, fineId);
    // Re-fetch fine with updated status
    const { data: updatedFine } = await supabase
      .from('fines')
      .select(
        '*, user:users(username, profile_pic), goal:goals(title)'
      )
      .eq('id', fineId)
      .single();
    
    if (updatedFine) {
      return {
        ...updatedFine,
        user: updatedFine.user,
        goal: updatedFine.goal,
        vote_result: voteResult,
      } as FineWithVotes;
    }
  }

  return {
    ...fine,
    user: fine.user,
    goal: fine.goal,
    vote_result: voteResult,
  } as FineWithVotes;
}

/**
 * Cast a vote on a fine
 */
export async function castVote(
  supabase: SupabaseClient,
  fineId: string,
  userId: string,
  input: VoteInput
): Promise<FineVote> {
  // Get fine and existing votes
  const { data: fine } = await supabase
    .from('fines')
    .select('user_id, status, voting_ends_at')
    .eq('id', fineId)
    .single();

  if (!fine) {
    throw new NotFoundError('Fine');
  }

  // Get existing votes
  const { data: existingVotes } = await supabase
    .from('fine_votes')
    .select('user_id, vote')
    .eq('fine_id', fineId);

  // Check if user can vote
  const canVote = canVoteOnFine(
    fine,
    userId,
    fine.user_id,
    existingVotes as FineVote[] || []
  );

  if (!canVote.canVote) {
    throw new ForbiddenError(canVote.reason || 'Cannot vote on this fine');
  }

  // Cast vote (RLS allows pack members to vote, unique constraint prevents duplicates)
  const { data: vote, error } = await supabase
    .from('fine_votes')
    .insert({
      fine_id: fineId,
      voter_id: userId,
      vote: input.vote,
    })
    .select('*, user:voter_id(username)')
    .single();

  if (error) {
    // Check if it's a duplicate vote (unique constraint violation)
    if (error.code === '23505') {
      throw new ConflictError('You have already voted on this fine');
    }
    console.error('Vote creation error:', error);
    throw new InternalError('Failed to cast vote');
  }

  if (!vote) {
    throw new InternalError('Failed to cast vote');
  }

  return {
    ...vote,
    user: vote.user,
  } as FineVote;
}

/**
 * Resolve a fine based on votes
 */
export async function resolveFine(
  supabase: SupabaseClient,
  fineId: string
): Promise<Fine> {
  // Get fine with votes
  const fineWithVotes = await getFineWithVotes(supabase, fineId);

  if (fineWithVotes.status !== 'voting') {
    throw new ValidationError('Fine is not in voting state');
  }

  const { consensus } = fineWithVotes.vote_result;
  const newStatus = determineFineStatus(consensus);

  // Update fine status (RLS allows pack members to update fines)
  const { data: updatedFine, error } = await supabase
    .from('fines')
    .update({
      status: newStatus,
    })
    .eq('id', fineId)
    .select(
      '*, user:users(username, profile_pic), goal:goals(title)'
    )
    .single();

  if (error || !updatedFine) {
    console.error('Fine resolution error:', error);
    throw new InternalError('Failed to resolve fine');
  }

  // If enforced, create punishment and transaction
  if (newStatus === 'enforced') {
    await createPunishment(supabase, updatedFine);
  }

  // Notify the fined user about resolution result
  await sendNotificationToUser(
    supabase,
    updatedFine.user_id,
    NotificationType.FINE_RESOLVED,
    {
      username: updatedFine.user?.username || 'You',
      amount: updatedFine.amount,
      fineId: updatedFine.id,
      enforced: newStatus === 'enforced',
    }
  );

  return {
    ...updatedFine,
    user: updatedFine.user,
    goal: updatedFine.goal,
  } as Fine;
}

/**
 * Create punishment record for enforced fine
 */
async function createPunishment(
  supabase: SupabaseClient,
  fine: Fine
): Promise<Punishment> {
  // Create punishment
  const { data: punishment, error } = await supabase
    .from('punishments')
    .insert({
      user_id: fine.user_id,
      pack_id: fine.pack_id,
      fine_id: fine.id,
      type: 'fine',
      amount: fine.amount,
      status: 'pending',
    })
    .select()
    .single();

  if (error || !punishment) {
    console.error('Punishment creation error:', error);
    throw new InternalError('Failed to create punishment');
  }

  // Create transaction placeholder
  await createTransactionPlaceholder(supabase, punishment);

  return punishment as Punishment;
}

/**
 * Create transaction placeholder for payment integration
 */
async function createTransactionPlaceholder(
  supabase: SupabaseClient,
  punishment: Punishment
): Promise<Transaction> {
  const { data: transaction, error } = await supabase
    .from('transactions')
    .insert({
      user_id: punishment.user_id,
      punishment_id: punishment.id,
      amount: punishment.amount,
      status: 'pending',
    })
    .select()
    .single();

  if (error || !transaction) {
    console.error('Transaction placeholder creation error:', error);
    throw new InternalError('Failed to create transaction');
  }

  return transaction as Transaction;
}

/**
 * Appeal a fine
 */
export async function appealFine(
  supabase: SupabaseClient,
  fineId: string,
  userId: string,
  input: AppealInput
): Promise<Fine> {
  // Get fine
  const { data: fine } = await supabase
    .from('fines')
    .select('user_id, status')
    .eq('id', fineId)
    .single();

  if (!fine) {
    throw new NotFoundError('Fine');
  }

  // Only the fined user can appeal
  if (fine.user_id !== userId) {
    throw new ForbiddenError('You can only appeal your own fines');
  }

  // Can only appeal enforced fines
  if (fine.status !== 'enforced') {
    throw new ValidationError('Can only appeal enforced fines');
  }

  // Create appeal record
  await supabase.from('fine_appeals').insert({
    fine_id: fineId,
    user_id: userId,
    reason: input.reason,
  });

  // Update fine status
  const { data: updatedFine, error } = await supabase
    .from('fines')
    .update({
      status: 'appealed',
      updated_at: new Date().toISOString(),
    })
    .eq('id', fineId)
    .select(
      '*, user:users(username, profile_pic), goal:goals(title)'
    )
    .single();

  if (error || !updatedFine) {
    console.error('Fine appeal error:', error);
    throw new InternalError('Failed to appeal fine');
  }

  // Notify pack members about the appeal
  await sendNotificationToPack(
    supabase,
    updatedFine.pack_id,
    NotificationType.FINE_APPEALED,
    {
      username: updatedFine.user?.username || 'Someone',
      fineId: updatedFine.id,
    },
    userId // Exclude the appealing user
  );

  return {
    ...updatedFine,
    user: updatedFine.user,
    goal: updatedFine.goal,
  } as Fine;
}

/**
 * List fines for a pack
 */
export async function listPackFines(
  supabase: SupabaseClient,
  packId: string,
  filters?: {
    status?: string;
    user_id?: string;
    limit?: number;
    offset?: number;
  }
): Promise<Fine[]> {
  let query = supabase
    .from('fines')
    .select(
      '*, user:users(username, profile_pic), goal:goals(title)'
    )
    .eq('pack_id', packId)
    .order('created_at', { ascending: false });

  if (filters?.status) {
    query = query.eq('status', filters.status);
  }

  if (filters?.user_id) {
    query = query.eq('user_id', filters.user_id);
  }

  query = query
    .limit(filters?.limit || 20)
    .range(
      filters?.offset || 0,
      (filters?.offset || 0) + (filters?.limit || 20) - 1
    );

  const { data: fines, error } = await query;

  if (error) {
    console.error('Pack fines fetch error:', error);
    throw new InternalError('Failed to fetch fines');
  }

  return (fines || []).map((fine) => ({
    ...fine,
    user: fine.user,
    goal: fine.goal,
  })) as Fine[];
}

/**
 * Get user's fines across all packs
 */
export async function getUserFines(
  supabase: SupabaseClient,
  userId: string
): Promise<Fine[]> {
  const { data: fines, error } = await supabase
    .from('fines')
    .select(
      '*, user:users(username, profile_pic), goal:goals(title)'
    )
    .eq('user_id', userId)
    .order('created_at', { ascending: false });

  if (error) {
    console.error('User fines fetch error:', error);
    return [];
  }

  return (fines || []).map((fine) => ({
    ...fine,
    user: fine.user,
    goal: fine.goal,
  })) as Fine[];
}
