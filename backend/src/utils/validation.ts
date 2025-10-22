import { Context } from 'hono';
import { z, ZodSchema } from 'zod';
import { ValidationError } from '../lib/errors';

/**
 * Validate request body against Zod schema
 * @throws ValidationError if validation fails
 */
export async function validateBody<T>(
  c: Context,
  schema: ZodSchema<T>
): Promise<T> {
  try {
    const body = await c.req.json();
    return schema.parse(body);
  } catch (error) {
    if (error instanceof z.ZodError) {
      throw new ValidationError(error.errors);
    }
    throw new ValidationError('Invalid request body');
  }
}

/**
 * Validate query parameters against Zod schema
 * @throws ValidationError if validation fails
 */
export function validateQuery<T>(c: Context, schema: ZodSchema<T>): T {
  try {
    const query = c.req.query();
    return schema.parse(query);
  } catch (error) {
    if (error instanceof z.ZodError) {
      throw new ValidationError(error.errors);
    }
    throw new ValidationError('Invalid query parameters');
  }
}

/**
 * Validate URL parameters against Zod schema
 * @throws ValidationError if validation fails
 */
export function validateParams<T>(c: Context, schema: ZodSchema<T>): T {
  try {
    const params = c.req.param();
    return schema.parse(params);
  } catch (error) {
    if (error instanceof z.ZodError) {
      throw new ValidationError(error.errors);
    }
    throw new ValidationError('Invalid URL parameters');
  }
}

// Common Zod schemas for reuse

/**
 * UUID validation schema
 */
export const uuidSchema = z.string().uuid('Invalid UUID format');

/**
 * Pagination query parameters schema
 */
export const paginationSchema = z.object({
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(100).default(20),
});

export type PaginationParams = z.infer<typeof paginationSchema>;

/**
 * Date range schema
 */
export const dateRangeSchema = z.object({
  startDate: z.string().datetime().optional(),
  endDate: z.string().datetime().optional(),
});

export type DateRangeParams = z.infer<typeof dateRangeSchema>;

/**
 * ID parameter schema
 */
export const idParamSchema = z.object({
  id: uuidSchema,
});

export type IdParam = z.infer<typeof idParamSchema>;

/**
 * Sort parameter schema
 */
export const sortSchema = z.object({
  sortBy: z.string().optional(),
  sortOrder: z.enum(['asc', 'desc']).default('desc'),
});

export type SortParams = z.infer<typeof sortSchema>;

/**
 * Phone number validation
 */
export const phoneSchema = z
  .string()
  .regex(/^\+?[1-9]\d{1,14}$/, 'Invalid phone number format');

/**
 * Email validation
 */
export const emailSchema = z.string().email('Invalid email format');

/**
 * Username validation (alphanumeric, underscores, 3-20 chars)
 */
export const usernameSchema = z
  .string()
  .min(3, 'Username must be at least 3 characters')
  .max(20, 'Username must be at most 20 characters')
  .regex(/^[a-zA-Z0-9_]+$/, 'Username can only contain letters, numbers, and underscores');

/**
 * URL validation
 */
export const urlSchema = z.string().url('Invalid URL format');

/**
 * Helper to parse pagination parameters
 */
export function getPagination(c: Context): PaginationParams {
  return validateQuery(c, paginationSchema);
}

/**
 * Calculate offset for database queries
 */
export function calculateOffset(page: number, limit: number): number {
  return (page - 1) * limit;
}

/**
 * Create pagination metadata
 */
export function createPaginationMeta(
  page: number,
  limit: number,
  total: number
) {
  const totalPages = Math.ceil(total / limit);
  return {
    page,
    limit,
    total,
    totalPages,
    hasMore: page < totalPages,
    hasPrevious: page > 1,
  };
}
