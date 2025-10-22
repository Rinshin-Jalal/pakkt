import { Context, Next } from 'hono';

export async function corsMiddleware(c: Context, next: Next) {
  // Allow iOS app origin
  c.header('Access-Control-Allow-Origin', '*'); // TODO: Restrict in production
  c.header('Access-Control-Allow-Methods', 'GET, POST, PATCH, DELETE, OPTIONS');
  c.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  c.header('Access-Control-Max-Age', '86400'); // 24 hours

  if (c.req.method === 'OPTIONS') {
    return c.text('', 204);
  }

  await next();
}
