/**
 * Fine data structure
 */
export interface Fine {
  id: string;
  pack_id: string;
  user_id: string;
  goal_id: string;
  check_in_id?: string;
  amount: number; // In cents
  reason: string;
  status: 'pending' | 'voting' | 'enforced' | 'cancelled' | 'appealed';
  voting_ends_at?: string;
  resolved_at?: string;
  created_at: string;
  updated_at: string;
  user?: {
    username: string;
    profile_pic?: string;
  };
  goal?: {
    title: string;
  };
}

/**
 * Fine vote
 */
export interface FineVote {
  id: string;
  fine_id: string;
  user_id: string;
  vote: boolean; // true = enforce, false = dismiss
  comment?: string;
  created_at: string;
  user?: {
    username: string;
  };
}

/**
 * Vote result with consensus
 */
export interface VoteResult {
  fine_id: string;
  total_votes: number;
  enforce_votes: number;
  dismiss_votes: number;
  consensus: 'enforce' | 'dismiss' | 'pending';
  voting_closed: boolean;
  votes: FineVote[];
}

/**
 * Fine with vote details
 */
export interface FineWithVotes extends Fine {
  vote_result: VoteResult;
}

/**
 * Punishment record
 */
export interface Punishment {
  id: string;
  user_id: string;
  pack_id: string;
  fine_id: string;
  type: 'fine' | 'jail';
  amount: number; // In cents
  status: 'pending' | 'paid' | 'cancelled';
  paid_at?: string;
  created_at: string;
}

/**
 * Input for creating a fine
 */
export interface CreateFineInput {
  user_id: string;
  goal_id: string;
  check_in_id?: string;
  reason: string;
  amount?: number; // Optional, uses goal default if not provided
}

/**
 * Input for casting a vote
 */
export interface VoteInput {
  vote: boolean; // true = enforce, false = dismiss
  comment?: string;
}

/**
 * Input for appeal
 */
export interface AppealInput {
  reason: string;
}

/**
 * Transaction placeholder
 */
export interface Transaction {
  id: string;
  user_id: string;
  punishment_id: string;
  amount: number;
  status: 'pending' | 'completed' | 'failed';
  payment_method?: string;
  created_at: string;
}
