import { z } from 'zod';
import { uuidSchema } from '../../utils/validation';

/**
 * Supported emojis
 */
const emojiSchema = z.enum(['🔥', '💪', '👏', '🎉', '😂', '❤️', '👀'], {
  errorMap: () => ({ message: 'Invalid emoji. Supported: 🔥 💪 👏 🎉 😂 ❤️ 👀' }),
});

/**
 * Schema for creating a reaction
 */
export const createReactionSchema = z
  .object({
    check_in_id: uuidSchema.optional(),
    feed_event_id: uuidSchema.optional(),
    emoji: emojiSchema,
  })
  .refine((data) => data.check_in_id || data.feed_event_id, {
    message: 'Either check_in_id or feed_event_id must be provided',
  });

export type CreateReactionData = z.infer<typeof createReactionSchema>;

/**
 * Schema for creating a comment
 */
export const createCommentSchema = z.object({
  check_in_id: uuidSchema,
  content: z
    .string()
    .min(1, 'Comment cannot be empty')
    .max(500, 'Comment must be at most 500 characters'),
});

export type CreateCommentData = z.infer<typeof createCommentSchema>;

/**
 * Schema for editing a comment
 */
export const editCommentSchema = z.object({
  content: z
    .string()
    .min(1, 'Comment cannot be empty')
    .max(500, 'Comment must be at most 500 characters'),
});

export type EditCommentData = z.infer<typeof editCommentSchema>;

/**
 * Schema for reaction ID parameter
 */
export const reactionIdParamSchema = z.object({
  id: uuidSchema,
});

/**
 * Schema for comment ID parameter
 */
export const commentIdParamSchema = z.object({
  id: uuidSchema,
});

/**
 * Schema for check-in ID parameter (for reactions/comments list)
 */
export const checkInIdParamSchema = z.object({
  checkInId: uuidSchema,
});
