#!/bin/bash

# Get Authentication Token for Testing Pakkt API
# Creates a test user if needed and returns a valid JWT token

set -e

# Load environment variables from .dev.vars
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/load-env.sh"

echo "🔐 Pakkt API - Get Auth Token"
echo "=============================="
echo ""

# Default test user credentials
DEFAULT_EMAIL="hey@rinsh.in"
DEFAULT_PASSWORD="Rinu@2005"

# Allow custom email/password
EMAIL="${1:-$DEFAULT_EMAIL}"
PASSWORD="${2:-$DEFAULT_PASSWORD}"

# Load environment variables
if ! load_dev_vars; then
    exit 1
fi

# Check if required variables are set
if ! check_required_vars; then
    exit 1
fi

echo "📧 Using credentials:"
echo "  Email: $EMAIL"
echo "  Password: $PASSWORD"
echo ""
echo "🌐 Using Supabase URL: $SUPABASE_URL"
echo ""

# Try to sign in first
echo "🔄 Attempting to sign in..."
RESPONSE=$(curl -s -X POST "$SUPABASE_URL/auth/v1/token?grant_type=password" \
  -H "apikey: $SUPABASE_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}")

# Check if sign in was successful
if echo "$RESPONSE" | grep -q "access_token"; then
    echo "✅ Sign in successful!"
else
    echo "⚠️  User doesn't exist or wrong password. Creating new user..."

    # Try to sign up
    SIGNUP_RESPONSE=$(curl -s -X POST "$SUPABASE_URL/auth/v1/signup" \
      -H "apikey: $SUPABASE_ANON_KEY" \
      -H "Content-Type: application/json" \
      -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}")

    if echo "$SIGNUP_RESPONSE" | grep -q "access_token"; then
        echo "✅ New user created successfully!"
        RESPONSE="$SIGNUP_RESPONSE"
    else
        echo "❌ Failed to create user"
        echo "Response: $SIGNUP_RESPONSE"
        exit 1
    fi
fi

echo ""

# Extract token using both jq (if available) and grep fallback
if command -v jq &> /dev/null; then
    TOKEN=$(echo "$RESPONSE" | jq -r '.access_token')
    USER_ID=$(echo "$RESPONSE" | jq -r '.user.id')
    EXPIRES_IN=$(echo "$RESPONSE" | jq -r '.expires_in')
else
    # Fallback to grep/sed if jq not available
    TOKEN=$(echo "$RESPONSE" | grep -o '"access_token":"[^"]*' | sed 's/"access_token":"//')
    USER_ID=$(echo "$RESPONSE" | grep -o '"id":"[^"]*' | head -1 | sed 's/"id":"//')
    EXPIRES_IN=$(echo "$RESPONSE" | grep -o '"expires_in":[0-9]*' | sed 's/"expires_in"://')
fi

if [ -z "$TOKEN" ] || [ "$TOKEN" = "null" ]; then
    echo "❌ Failed to get token"
    echo "Response: $RESPONSE"
    exit 1
fi

echo "✅ Auth Token Generated!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Token Details:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "User ID:    $USER_ID"
echo "Email:      $EMAIL"
echo "Expires in: $EXPIRES_IN seconds (~$(($EXPIRES_IN / 60)) minutes)"
echo ""
echo "🔑 ACCESS TOKEN:"
echo "$TOKEN"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "💾 Saving to environment variable..."
export AUTH_TOKEN="$TOKEN"
echo "export AUTH_TOKEN=\"$TOKEN\"" > /tmp/pakkt-auth-token.sh
echo ""
echo "✅ Token saved!"
echo ""
echo "📌 How to use this token:"
echo ""
echo "Option 1: Copy-paste for immediate use"
echo "  export AUTH_TOKEN=\"$TOKEN\""
echo ""
echo "Option 2: Source the saved file (current session only)"
echo "  source /tmp/pakkt-auth-token.sh"
echo ""
echo "Option 3: Use in curl commands"
echo "  curl http://localhost:8787/api/users/profile \\"
echo "    -H \"Authorization: Bearer \$AUTH_TOKEN\""
echo ""
echo "Option 4: Run test scripts (they'll use AUTH_TOKEN env var)"
echo "  source /tmp/pakkt-auth-token.sh"
echo "  ./test-endpoints.sh"
echo ""
echo "💡 Quick test:"
echo "  export AUTH_TOKEN=\"$TOKEN\""
echo "  curl http://localhost:8787/api/users/profile -H \"Authorization: Bearer \$AUTH_TOKEN\""
echo ""
