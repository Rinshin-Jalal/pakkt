import { Context, Next } from "hono";
import { createSupabaseClient } from "../lib/supabase";
import type { Env } from "../types/env";

/**
 * Middleware to verify Supabase JWT tokens and extract user ID
 * Uses Supabase's built-in JWT verification - no custom JWT handling needed
 */
export const requireAuth = async (
  c: Context,
  next: Next
): Promise<Response | void> => {
  const authHeader = c.req.header("Authorization");

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return c.json({ error: "Authorization header required" }, 401);
  }

  const token = authHeader.replace("Bearer ", "");
  const env = c.env as Env;

  try {
    const supabase = createSupabaseClient(env);

    // Verify the JWT token with Supabase
    const {
      data: { user },
      error,
    } = await supabase.auth.getUser(token);

    if (error || !user) {
      console.error("Token verification failed:", error?.message);
      return c.json({ error: "Invalid or expired token" }, 401);
    }

    // Store user ID and token in context for use in route handlers
    c.set("userId", user.id);
    c.set("userEmail", user.email);
    c.set("accessToken", token); // Store token for RLS-aware Supabase client

    return await next();
  } catch (error) {
    console.error("Auth middleware error:", error);
    return c.json({ error: "Authentication failed" }, 500);
  }
};

/**
 * Middleware for optional authentication
 * Attaches user info to context if token is present and valid
 * Does not throw error if token is missing or invalid
 */
export const optionalAuth = async (
  c: Context,
  next: Next
): Promise<Response | void> => {
  const authHeader = c.req.header("Authorization");

  if (authHeader && authHeader.startsWith("Bearer ")) {
    const token = authHeader.replace("Bearer ", "");
    const env = c.env as Env;

    try {
      const supabase = createSupabaseClient(env);

      const {
        data: { user },
        error,
      } = await supabase.auth.getUser(token);

      if (!error && user) {
        // Attach user info and token to context
        c.set("userId", user.id);
        c.set("userEmail", user.email);
        c.set("accessToken", token);
      }
    } catch (error) {
      // Silently fail for optional auth
      console.warn("Optional auth failed:", error);
    }
  }

  return await next();
};

/**
 * Helper to get authenticated user ID from context
 */
export const getAuthenticatedUserId = (c: Context): string => {
  const userId = c.get("userId");
  if (!userId) {
    throw new Error(
      "User ID not found in context. Ensure requireAuth middleware is used."
    );
  }
  return userId;
};

/**
 * Get current user ID from context (alias for compatibility)
 */
export function getCurrentUserId(c: Context): string {
  return getAuthenticatedUserId(c);
}
