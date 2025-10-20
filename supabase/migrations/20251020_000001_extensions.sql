-- Enable required extensions
create extension if not exists pgcrypto;
create extension if not exists "uuid-ossp";

-- Optional: enable http networking for webhooks if needed
-- create extension if not exists pg_net;

-- Realtime publication will be managed by Supabase; tables are added automatically
-- via supabase-js subscriptions. Explicit publication changes can be added later if needed.


