import { Context } from 'hono';
import { APIError } from '../lib/errors';

export async function errorHandler(err: Error, c: Context) {
  console.error('[ERROR]', {
    message: err.message,
    stack: err.stack,
    path: c.req.path,
    method: c.req.method,
  });

  if (err instanceof APIError) {
    return c.json(
      {
        success: false,
        error: {
          code: err.code,
          message: err.message,
          details: err.details,
        },
      },
      err.statusCode
    );
  }

  // Unknown error - don't leak internal details
  return c.json(
    {
      success: false,
      error: {
        code: 'INTERNAL_ERROR',
        message: 'An unexpected error occurred',
      },
    },
    500
  );
}
