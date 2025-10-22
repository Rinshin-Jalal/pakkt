import type { FineVote, VoteResult } from './types';

/**
 * Calculate voting window end time (24 hours from creation)
 */
export function calculateVotingEndTime(createdAt: Date = new Date()): Date {
  const endTime = new Date(createdAt);
  endTime.setHours(endTime.getHours() + 24);
  return endTime;
}

/**
 * Check if voting window has closed
 */
export function isVotingClosed(votingEndsAt: string): boolean {
  return new Date() > new Date(votingEndsAt);
}

/**
 * Calculate consensus from votes
 * Rules:
 * - enforce_votes > dismiss_votes = 'enforce'
 * - enforce_votes <= dismiss_votes = 'dismiss'
 * - No votes yet = 'pending'
 */
export function calculateConsensus(
  enforceVotes: number,
  dismissVotes: number,
  votingClosed: boolean
): 'enforce' | 'dismiss' | 'pending' {
  const totalVotes = enforceVotes + dismissVotes;

  // No votes yet
  if (totalVotes === 0) {
    return 'pending';
  }

  // If voting still open and no clear majority
  if (!votingClosed && enforceVotes === dismissVotes) {
    return 'pending';
  }

  // Enforce wins if more enforce votes
  if (enforceVotes > dismissVotes) {
    return 'enforce';
  }

  // Dismiss wins otherwise (includes ties when voting closed)
  return 'dismiss';
}

/**
 * Process vote results and determine consensus
 */
export function processVoteResults(
  votes: FineVote[],
  votingEndsAt: string,
  packMemberCount: number
): VoteResult & { fine_id: string } {
  const fineId = votes[0]?.fine_id || '';
  
  const enforceVotes = votes.filter((v) => v.vote === true).length;
  const dismissVotes = votes.filter((v) => v.vote === false).length;
  const totalVotes = votes.length;

  const votingClosed = isVotingClosed(votingEndsAt);
  const consensus = calculateConsensus(enforceVotes, dismissVotes, votingClosed);

  return {
    fine_id: fineId,
    total_votes: totalVotes,
    enforce_votes: enforceVotes,
    dismiss_votes: dismissVotes,
    consensus,
    voting_closed: votingClosed,
    votes,
  };
}

/**
 * Check if user has already voted
 */
export function hasUserVoted(votes: FineVote[], userId: string): boolean {
  return votes.some((v) => v.user_id === userId);
}

/**
 * Calculate fine amount based on goal or pack defaults
 */
export function calculateFineAmount(
  goalFineAmount?: number,
  packDefaultFineAmount?: number
): number {
  // Use goal amount if available, otherwise pack default, otherwise $5
  return (goalFineAmount || packDefaultFineAmount || 5) * 100; // Convert to cents
}

/**
 * Check if fine should be auto-resolved
 */
export function shouldAutoResolve(fine: {
  status: string;
  voting_ends_at?: string;
}): boolean {
  return (
    fine.status === 'voting' &&
    fine.voting_ends_at !== undefined &&
    isVotingClosed(fine.voting_ends_at)
  );
}

/**
 * Generate fine reason for missed check-in
 */
export function generateMissedCheckInReason(
  goalTitle: string,
  date: Date = new Date()
): string {
  const dateStr = date.toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  });
  return `Missed check-in for "${goalTitle}" on ${dateStr}`;
}

/**
 * Determine fine status after resolution
 */
export function determineFineStatus(consensus: 'enforce' | 'dismiss' | 'pending'): string {
  switch (consensus) {
    case 'enforce':
      return 'enforced';
    case 'dismiss':
      return 'cancelled';
    case 'pending':
      return 'voting'; // Keep in voting if still pending
    default:
      return 'voting';
  }
}

/**
 * Check if user can vote on fine
 */
export function canVoteOnFine(
  fine: { status: string; voting_ends_at?: string },
  userId: string,
  fineUserId: string,
  votes: FineVote[]
): { canVote: boolean; reason?: string } {
  // Can't vote on own fine
  if (userId === fineUserId) {
    return { canVote: false, reason: 'Cannot vote on your own fine' };
  }

  // Can only vote when status is 'voting'
  if (fine.status !== 'voting') {
    return { canVote: false, reason: 'Fine is not in voting state' };
  }

  // Check if voting window closed
  if (fine.voting_ends_at && isVotingClosed(fine.voting_ends_at)) {
    return { canVote: false, reason: 'Voting window has closed' };
  }

  // Check if already voted
  if (hasUserVoted(votes, userId)) {
    return { canVote: false, reason: 'You have already voted on this fine' };
  }

  return { canVote: true };
}
