#!/bin/bash

# Simple Test User Creation with Unique Usernames
# Uses timestamp to ensure unique usernames

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/load-env.sh"

echo "👥 Pakkt API - Simple Test Users"
echo "================================="
echo ""

# Load environment variables
if ! load_dev_vars; then
    exit 1
fi

if ! check_required_vars; then
    exit 1
fi

echo "🌐 Using Supabase URL: $SUPABASE_URL"
echo ""

# Get existing user token (Alice)
echo "🔧 Getting existing user token (Alice)..."
RESPONSE=$(curl -s -X POST "$SUPABASE_URL/auth/v1/token?grant_type=password" \
    -H "apikey: $SUPABASE_ANON_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"hey@rinsh.in\",\"password\":\"Rinu@2005\"}")

if echo "$RESPONSE" | grep -q "access_token"; then
    if command -v jq &> /dev/null; then
        ALICE_TOKEN=$(echo "$RESPONSE" | jq -r '.access_token')
        ALICE_ID=$(echo "$RESPONSE" | jq -r '.user.id')
    else
        ALICE_TOKEN=$(echo "$RESPONSE" | grep -o '"access_token":"[^"]*' | sed 's/"access_token":"//')
        ALICE_ID=$(echo "$RESPONSE" | grep -o '"id":"[^"]*' | head -1 | sed 's/"id":"//')
    fi
    echo "✅ Alice (existing user) token retrieved!"
    echo "   User ID: $ALICE_ID"
else
    echo "❌ Failed to get existing user token"
    exit 1
fi
echo ""

# Create Bob with unique username
echo "🔧 Creating Bob..."
TIMESTAMP=$(date +%s)
BOB_USERNAME="bob${TIMESTAMP}"
BOB_EMAIL="${BOB_USERNAME}@pakkt.test"

BOB_RESPONSE=$(curl -s -X POST "$SUPABASE_URL/auth/v1/signup" \
    -H "apikey: $SUPABASE_ANON_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"$BOB_EMAIL\",\"password\":\"Bob123!\",\"data\":{\"username\":\"$BOB_USERNAME\",\"display_name\":\"Bob\"}}")

if echo "$BOB_RESPONSE" | grep -q "access_token"; then
    if command -v jq &> /dev/null; then
        BOB_TOKEN=$(echo "$BOB_RESPONSE" | jq -r '.access_token')
        BOB_ID=$(echo "$BOB_RESPONSE" | jq -r '.user.id')
    else
        BOB_TOKEN=$(echo "$BOB_RESPONSE" | grep -o '"access_token":"[^"]*' | sed 's/"access_token":"//')
        BOB_ID=$(echo "$BOB_RESPONSE" | grep -o '"id":"[^"]*' | head -1 | sed 's/"id":"//')
    fi
    echo "✅ Bob created successfully!"
    echo "   Username: $BOB_USERNAME"
    echo "   Email: $BOB_EMAIL"
    echo "   User ID: $BOB_ID"
else
    echo "❌ Failed to create Bob"
    echo "Response: $BOB_RESPONSE"
    exit 1
fi
echo ""

# Create Charlie with unique username
echo "🔧 Creating Charlie..."
TIMESTAMP2=$((TIMESTAMP + 1))
CHARLIE_USERNAME="charlie${TIMESTAMP2}"
CHARLIE_EMAIL="${CHARLIE_USERNAME}@pakkt.test"

CHARLIE_RESPONSE=$(curl -s -X POST "$SUPABASE_URL/auth/v1/signup" \
    -H "apikey: $SUPABASE_ANON_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"$CHARLIE_EMAIL\",\"password\":\"Charlie123!\",\"data\":{\"username\":\"$CHARLIE_USERNAME\",\"display_name\":\"Charlie\"}}")

if echo "$CHARLIE_RESPONSE" | grep -q "access_token"; then
    if command -v jq &> /dev/null; then
        CHARLIE_TOKEN=$(echo "$CHARLIE_RESPONSE" | jq -r '.access_token')
        CHARLIE_ID=$(echo "$CHARLIE_RESPONSE" | jq -r '.user.id')
    else
        CHARLIE_TOKEN=$(echo "$CHARLIE_RESPONSE" | grep -o '"access_token":"[^"]*' | sed 's/"access_token":"//')
        CHARLIE_ID=$(echo "$CHARLIE_RESPONSE" | grep -o '"id":"[^"]*' | head -1 | sed 's/"id":"//')
    fi
    echo "✅ Charlie created successfully!"
    echo "   Username: $CHARLIE_USERNAME"
    echo "   Email: $CHARLIE_EMAIL"
    echo "   User ID: $CHARLIE_ID"
else
    echo "❌ Failed to create Charlie"
    echo "Response: $CHARLIE_RESPONSE"
    exit 1
fi
echo ""

# Save all tokens to file
cat > /tmp/pakkt-test-users.sh << EOF
#!/bin/bash
# Pakkt Test Users Environment Variables

# Alice (Pack Creator - existing user)
export ALICE_TOKEN="$ALICE_TOKEN"
export ALICE_ID="$ALICE_ID"
export ALICE_EMAIL="hey@rinsh.in"

# Bob (Pack Member)
export BOB_TOKEN="$BOB_TOKEN"
export BOB_ID="$BOB_ID"
export BOB_EMAIL="$BOB_EMAIL"
export BOB_USERNAME="$BOB_USERNAME"

# Charlie (Pack Member)
export CHARLIE_TOKEN="$CHARLIE_TOKEN"
export CHARLIE_ID="$CHARLIE_ID"
export CHARLIE_EMAIL="$CHARLIE_EMAIL"
export CHARLIE_USERNAME="$CHARLIE_USERNAME"

# API Base URL
export API_BASE="http://localhost:8787"
EOF

echo "✅ All test users ready!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Test Users Summary:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "👑 Alice (Pack Creator):"
echo "   Email: hey@rinsh.in"
echo "   ID: $ALICE_ID"
echo "   Token: \${ALICE_TOKEN}"
echo ""
echo "👤 Bob (Member):"
echo "   Username: $BOB_USERNAME"
echo "   Email: $BOB_EMAIL"
echo "   ID: $BOB_ID"
echo "   Token: \${BOB_TOKEN}"
echo ""
echo "👤 Charlie (Member):"
echo "   Username: $CHARLIE_USERNAME"
echo "   Email: $CHARLIE_EMAIL"
echo "   ID: $CHARLIE_ID"
echo "   Token: \${CHARLIE_TOKEN}"
echo ""
echo "💾 Environment file saved to: /tmp/pakkt-test-users.sh"
echo ""
echo "🧪 Load and test:"
echo "  source /tmp/pakkt-test-users.sh"
echo "  curl \$API_BASE/api/users/profile -H \"Authorization: Bearer \$ALICE_TOKEN\""
echo ""