import { Context, Next } from 'hono';

export async function corsMiddleware(c: Context, next: Next) {
  // Mobile-only API: Native iOS apps don't require CORS headers
  // CORS is a browser security feature - native HTTP clients bypass it
  // Security handled by: JWT auth + Supabase RLS policies

  await next();
}
