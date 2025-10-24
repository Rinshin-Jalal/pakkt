import { createClient, SupabaseClient } from '@supabase/supabase-js';
import type { Env } from '../types/env';
import { Context } from 'hono';

/**
 * Create a Supabase client with service role access
 * Use this for server-side operations that bypass RLS
 */
export function createSupabaseClient(env: Env): SupabaseClient {
  return createClient(env.SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY, {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
      detectSessionInUrl: false,
    },
  });
}

/**
 * Get Supabase client from Hono context with user authentication
 * Creates a new client if one doesn't exist
 * This client respects RLS policies using the user's JWT token
 */
export function getSupabaseClient(c: Context): SupabaseClient {
  // Check if client already exists in context
  let client = c.get('supabase');

  if (!client) {
    // Get user's JWT token from auth middleware
    const accessToken = c.get('accessToken');
    const env = c.env as Env;

    if (accessToken) {
      // Create client with user's auth token (respects RLS)
      client = createSupabaseClientWithAuth(env, accessToken);
    } else {
      // Fallback to service role (bypasses RLS) if no token
      client = createSupabaseClient(env);
    }

    c.set('supabase', client);
  }

  return client;
}

/**
 * Create a Supabase client with user's JWT token
 * Use this for operations that respect RLS policies
 */
export function createSupabaseClientWithAuth(
  env: Env,
  accessToken: string
): SupabaseClient {
  return createClient(env.SUPABASE_URL, env.SUPABASE_ANON_KEY, {
    global: {
      headers: {
        Authorization: `Bearer ${accessToken}`,
        apikey: env.SUPABASE_ANON_KEY,
      },
    },
    auth: {
      autoRefreshToken: false,
      persistSession: false,
      detectSessionInUrl: false,
    },
  });
}
