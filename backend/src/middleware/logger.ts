import { Context, Next } from 'hono';

export async function loggerMiddleware(c: Context, next: Next) {
  const start = Date.now();
  const { method, path } = c.req;

  await next();

  const duration = Date.now() - start;
  const status = c.res.status;

  console.log(
    `[${new Date().toISOString()}] ${method} ${path} - ${status} (${duration}ms)`
  );
}
