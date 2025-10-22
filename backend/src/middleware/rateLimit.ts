import { Context, Next } from 'hono';
import { RateLimitError } from '../lib/errors';

interface RateLimitConfig {
  windowMs: number; // Time window in milliseconds
  maxRequests: number; // Max requests per window
}

const defaultConfig: RateLimitConfig = {
  windowMs: 60 * 1000, // 1 minute
  maxRequests: 60, // 60 requests per minute
};

// In-memory store (use KV in production)
const requestCounts = new Map<string, { count: number; resetAt: number }>();

export function rateLimitMiddleware(config: RateLimitConfig = defaultConfig) {
  return async (c: Context, next: Next) => {
    // Get user ID from context (set by auth middleware) or IP
    const userId = c.get('userId') || c.req.header('CF-Connecting-IP') || 'anonymous';
    const key = `ratelimit:${userId}`;
    const now = Date.now();

    let record = requestCounts.get(key);

    // Reset if window expired
    if (!record || now > record.resetAt) {
      record = {
        count: 0,
        resetAt: now + config.windowMs,
      };
      requestCounts.set(key, record);
    }

    record.count++;

    if (record.count > config.maxRequests) {
      throw new RateLimitError();
    }

    // Add rate limit headers
    c.header('X-RateLimit-Limit', config.maxRequests.toString());
    c.header('X-RateLimit-Remaining', (config.maxRequests - record.count).toString());
    c.header('X-RateLimit-Reset', new Date(record.resetAt).toISOString());

    await next();
  };
}
