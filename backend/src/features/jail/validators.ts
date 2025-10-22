import { z } from 'zod';
import { uuidSchema } from '../../utils/validation';

/**
 * Schema for starting jail session
 */
export const startJailSchema = z.object({
  goal_id: uuidSchema,
  fine_id: uuidSchema.optional(),
  duration_minutes: z
    .number()
    .int()
    .min(15, 'Duration must be at least 15 minutes')
    .max(120, 'Duration must be at most 120 minutes')
    .optional(),
  blocked_apps: z
    .array(z.string())
    .min(1, 'At least one app must be blocked')
    .max(50, 'Cannot block more than 50 apps'),
});

export type StartJailData = z.infer<typeof startJailSchema>;

/**
 * Schema for heartbeat
 */
export const heartbeatSchema = z.object({
  timestamp: z.string().datetime().optional(),
});

export type HeartbeatData = z.infer<typeof heartbeatSchema>;

/**
 * Schema for break jail
 */
export const breakJailSchema = z.object({
  payment_method: z.string().optional(),
});

export type BreakJailData = z.infer<typeof breakJailSchema>;

/**
 * Schema for jail ID parameter
 */
export const jailIdParamSchema = z.object({
  id: uuidSchema,
});
