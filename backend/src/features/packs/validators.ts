import { z } from 'zod';
import { uuidSchema } from '../../utils/validation';

/**
 * Schema for creating a new pack
 */
export const createPackSchema = z.object({
  name: z
    .string()
    .min(3, 'Pack name must be at least 3 characters')
    .max(50, 'Pack name must be at most 50 characters'),
  goal_type: z
    .string()
    .optional(),
});

export type CreatePackData = z.infer<typeof createPackSchema>;

/**
 * Schema for updating a pack
 */
export const updatePackSchema = z.object({
  name: z
    .string()
    .min(3, 'Pack name must be at least 3 characters')
    .max(50, 'Pack name must be at most 50 characters')
    .optional(),
  description: z
    .string()
    .max(500, 'Description must be at most 500 characters')
    .optional(),
  visibility: z
    .enum(['private', 'pack', 'public'])
    .optional(),
  default_fine_amount: z
    .number()
    .int()
    .min(1, 'Fine amount must be at least $1')
    .max(20, 'Fine amount must be at most $20')
    .optional(),
  default_jail_duration: z
    .number()
    .int()
    .min(15, 'Jail duration must be at least 15 minutes')
    .max(120, 'Jail duration must be at most 120 minutes')
    .optional(),
});

export type UpdatePackData = z.infer<typeof updatePackSchema>;

/**
 * Schema for adding a member
 */
export const addMemberSchema = z.object({
  user_id: uuidSchema.optional(),
  invite_code: z.string().optional(),
}).refine(
  (data) => data.user_id || data.invite_code,
  {
    message: 'Either user_id or invite_code must be provided',
  }
);

export type AddMemberData = z.infer<typeof addMemberSchema>;

/**
 * Schema for pack ID parameter
 */
export const packIdParamSchema = z.object({
  id: uuidSchema,
});

/**
 * Schema for member removal
 */
export const removeMemberParamSchema = z.object({
  id: uuidSchema,
  userId: uuidSchema,
});
