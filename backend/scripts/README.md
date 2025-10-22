# Pakkt Backend Scripts

This directory contains utility scripts for the Pakkt backend that automatically load environment variables from `.dev.vars`.

## Scripts Overview

### 🔧 Setup Scripts

- **`setup-env.sh`** - Creates `.dev.vars` file with Supabase credentials
- **`load-env.sh`** - Common environment loader (used by other scripts)

### 🔐 Authentication Scripts

- **`get-auth-token.sh`** - Gets JWT token for API testing

### 🧪 Testing Scripts

- **`test-all.sh`** - Complete test suite for all endpoints
- **`test-endpoints.sh`** - Comprehensive endpoint testing
- **`test-flows.sh`** - End-to-end user flow testing
- **`test-complete-api.sh`** - Complete API testing with ID tracking

## Quick Start

1. **Setup Environment** (first time only):
   ```bash
   ./scripts/setup-env.sh
   ```

2. **Get Auth Token**:
   ```bash
   ./scripts/get-auth-token.sh
   ```

3. **Run Tests**:
   ```bash
   # Run all tests
   ./scripts/test-all.sh
   
   # Run specific test suite
   ./scripts/test-endpoints.sh
   ./scripts/test-flows.sh
   ```

## How It Works

All scripts automatically:
- Load environment variables from `.dev.vars`
- Use Supabase URL and keys from the environment
- Provide helpful error messages if variables are missing

## Environment Variables Used

The scripts use these variables from `.dev.vars`:
- `SUPABASE_URL` - Supabase project URL
- `SUPABASE_ANON_KEY` - Supabase anonymous key
- `SUPABASE_SERVICE_ROLE_KEY` - Supabase service role key
- `ENVIRONMENT` - Environment name (development/production)

## Customization

You can override any environment variable:
```bash
# Use custom API URL
API_URL="http://localhost:3000" ./scripts/test-all.sh

# Use custom auth token
AUTH_TOKEN="your-token" ./scripts/test-flows.sh
```

## Troubleshooting

If you get "environment variables not found" errors:
1. Run `./scripts/setup-env.sh` to create `.dev.vars`
2. Make sure Supabase is running (`supabase start`)
3. Check that `.dev.vars` contains valid Supabase credentials