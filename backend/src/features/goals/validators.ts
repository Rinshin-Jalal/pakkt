import { z } from 'zod';
import { uuidSchema } from '../../utils/validation';

/**
 * Time format validation (HH:MM in 24-hour format)
 */
const timeSchema = z
  .string()
  .regex(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/, 'Invalid time format. Use HH:MM (24-hour format)');

/**
 * Days of week validation (0-6, Sunday-Saturday)
 */
const daysOfWeekSchema = z
  .array(z.number().int().min(0).max(6))
  .min(1, 'At least one day must be selected')
  .refine(
    (days) => new Set(days).size === days.length,
    { message: 'Duplicate days not allowed' }
  );

/**
 * Recurrence rule schema
 */
const recurrenceRuleSchema = z.object({
  type: z.enum(['daily', 'weekly', 'custom'], {
    errorMap: () => ({ message: 'Type must be daily, weekly, or custom' }),
  }),
  interval: z
    .number()
    .int()
    .min(1, 'Interval must be at least 1')
    .max(30, 'Interval must be at most 30'),
  days_of_week: daysOfWeekSchema.optional(),
  end_date: z.string().datetime().optional(),
}).refine(
  (data) => {
    // If weekly, days_of_week is required
    if (data.type === 'weekly' && !data.days_of_week) {
      return false;
    }
    return true;
  },
  {
    message: 'days_of_week is required for weekly recurrence',
    path: ['days_of_week'],
  }
);

/**
 * Schema for creating a new goal
 */
export const createGoalSchema = z.object({
  title: z
    .string()
    .min(3, 'Goal title must be at least 3 characters')
    .max(100, 'Goal title must be at most 100 characters'),
  description: z
    .string()
    .max(500, 'Description must be at most 500 characters')
    .optional(),
  check_in_time: timeSchema,
  recurrence_rule: recurrenceRuleSchema,
  fine_amount: z
    .number()
    .int()
    .min(1, 'Fine amount must be at least $1')
    .max(20, 'Fine amount must be at most $20')
    .optional(),
  jail_duration: z
    .number()
    .int()
    .min(15, 'Jail duration must be at least 15 minutes')
    .max(120, 'Jail duration must be at most 120 minutes')
    .optional(),
  proof_required: z.boolean().default(false),
  base_xp: z
    .number()
    .int()
    .min(10, 'Base XP must be at least 10')
    .max(500, 'Base XP must be at most 500')
    .default(100),
});

export type CreateGoalData = z.infer<typeof createGoalSchema>;

/**
 * Schema for updating a goal
 */
export const updateGoalSchema = z.object({
  title: z
    .string()
    .min(3, 'Goal title must be at least 3 characters')
    .max(100, 'Goal title must be at most 100 characters')
    .optional(),
  description: z
    .string()
    .max(500, 'Description must be at most 500 characters')
    .optional(),
  check_in_time: timeSchema.optional(),
  recurrence_rule: recurrenceRuleSchema.optional(),
  fine_amount: z
    .number()
    .int()
    .min(1, 'Fine amount must be at least $1')
    .max(20, 'Fine amount must be at most $20')
    .optional(),
  jail_duration: z
    .number()
    .int()
    .min(15, 'Jail duration must be at least 15 minutes')
    .max(120, 'Jail duration must be at most 120 minutes')
    .optional(),
  proof_required: z.boolean().optional(),
  base_xp: z
    .number()
    .int()
    .min(10, 'Base XP must be at least 10')
    .max(500, 'Base XP must be at most 500')
    .optional(),
});

export type UpdateGoalData = z.infer<typeof updateGoalSchema>;

/**
 * Schema for goal ID parameter
 */
export const goalIdParamSchema = z.object({
  id: uuidSchema,
});

/**
 * Schema for pack ID parameter with goal listing
 */
export const packGoalsParamSchema = z.object({
  packId: uuidSchema,
});

/**
 * Schema for filtering goals
 */
export const goalsFilterSchema = z.object({
  is_active: z
    .string()
    .optional()
    .transform((val) => (val === 'true' ? true : val === 'false' ? false : undefined)),
  user_id: uuidSchema.optional(),
});

export type GoalsFilter = z.infer<typeof goalsFilterSchema>;
