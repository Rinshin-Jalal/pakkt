import { z } from 'zod';
import { uuidSchema, urlSchema } from '../../utils/validation';

/**
 * Schema for creating a check-in
 */
export const createCheckInSchema = z.object({
  goal_id: uuidSchema,
  proof_url: urlSchema.optional(),
  caption: z
    .string()
    .max(500, 'Caption must be at most 500 characters')
    .optional(),
});

export type CreateCheckInData = z.infer<typeof createCheckInSchema>;

/**
 * Schema for check-in ID parameter
 */
export const checkInIdParamSchema = z.object({
  id: uuidSchema,
});

/**
 * Schema for feed filters
 */
export const feedFilterSchema = z.object({
  pack_id: uuidSchema.optional(),
  limit: z.coerce.number().int().min(1).max(100).default(20),
  offset: z.coerce.number().int().min(0).default(0),
});

export type FeedFilter = z.infer<typeof feedFilterSchema>;

/**
 * Schema for pack check-ins filters
 */
export const packCheckInsFilterSchema = z.object({
  user_id: uuidSchema.optional(),
  goal_id: uuidSchema.optional(),
  status: z.enum(['pending', 'verified', 'late', 'missed']).optional(),
  limit: z.coerce.number().int().min(1).max(100).default(20),
  offset: z.coerce.number().int().min(0).default(0),
});

export type PackCheckInsFilter = z.infer<typeof packCheckInsFilterSchema>;

/**
 * Schema for verify check-in
 */
export const verifyCheckInSchema = z.object({
  verified: z.boolean(),
});

export type VerifyCheckInData = z.infer<typeof verifyCheckInSchema>;
