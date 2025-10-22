import { z } from 'zod';
import { uuidSchema } from '../../utils/validation';

/**
 * Schema for creating a fine
 */
export const createFineSchema = z.object({
  user_id: uuidSchema,
  goal_id: uuidSchema,
  check_in_id: uuidSchema.optional(),
  reason: z
    .string()
    .min(10, 'Reason must be at least 10 characters')
    .max(500, 'Reason must be at most 500 characters'),
  amount: z
    .number()
    .int()
    .min(100, 'Amount must be at least $1')
    .max(2000, 'Amount must be at most $20')
    .optional(),
});

export type CreateFineData = z.infer<typeof createFineSchema>;

/**
 * Schema for voting
 */
export const voteSchema = z.object({
  vote: z.boolean({
    required_error: 'Vote is required',
    invalid_type_error: 'Vote must be true (enforce) or false (dismiss)',
  }),
  comment: z
    .string()
    .max(500, 'Comment must be at most 500 characters')
    .optional(),
});

export type VoteData = z.infer<typeof voteSchema>;

/**
 * Schema for appeal
 */
export const appealSchema = z.object({
  reason: z
    .string()
    .min(20, 'Appeal reason must be at least 20 characters')
    .max(1000, 'Appeal reason must be at most 1000 characters'),
});

export type AppealData = z.infer<typeof appealSchema>;

/**
 * Schema for fine ID parameter
 */
export const fineIdParamSchema = z.object({
  id: uuidSchema,
});

/**
 * Schema for pack fines filters
 */
export const packFinesFilterSchema = z.object({
  status: z.enum(['pending', 'voting', 'enforced', 'cancelled', 'appealed']).optional(),
  user_id: uuidSchema.optional(),
  limit: z.coerce.number().int().min(1).max(100).default(20),
  offset: z.coerce.number().int().min(0).default(0),
});

export type PackFinesFilter = z.infer<typeof packFinesFilterSchema>;
