import { z } from 'zod';
import { usernameSchema, urlSchema } from '../../utils/validation';

/**
 * Schema for updating user profile
 */
export const updateProfileSchema = z.object({
  username: usernameSchema.optional(),
  display_name: z
    .string()
    .min(1, 'Display name cannot be empty')
    .max(50, 'Display name must be at most 50 characters')
    .optional(),
  avatar_url: urlSchema.optional(),
  bio: z
    .string()
    .max(500, 'Bio must be at most 500 characters')
    .optional(),
});

export type UpdateProfileData = z.infer<typeof updateProfileSchema>;

/**
 * Schema for push token registration
 */
export const pushTokenSchema = z.object({
  token: z.string().min(1, 'Push token is required'),
  device_type: z.enum(['ios', 'android'], {
    errorMap: () => ({ message: 'Device type must be ios or android' }),
  }),
  device_id: z.string().optional(),
});

export type PushTokenData = z.infer<typeof pushTokenSchema>;
