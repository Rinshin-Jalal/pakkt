#!/bin/bash

# Pakkt API - Setup Multiple Test Users
# Creates 3 test users (Alice, Bob, Charlie) and prints/saves their tokens

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/load-env.sh"

API_URL="${API_URL:-http://localhost:8787}"

USERS=(
  "alice@test.pakkt.app|Alice|Alice"
  "bob@test.pakkt.app|Bob|Bob"
  "charlie@test.pakkt.app|Charlie|Charlie"
)

DEFAULT_PASSWORD="Test@2025"

create_or_get_token() {
  local email="$1"
  local password="$2"

  local response=$(curl -s -X POST "$SUPABASE_URL/auth/v1/token?grant_type=password" \
    -H "apikey: $SUPABASE_ANON_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"$email\",\"password\":\"$password\"}")

  if echo "$response" | grep -q "access_token"; then
    echo "$response"
  else
    local signup=$(curl -s -X POST "$SUPABASE_URL/auth/v1/signup" \
      -H "apikey: $SUPABASE_ANON_KEY" \
      -H "Content-Type: application/json" \
      -d "{\"email\":\"$email\",\"password\":\"$password\"}")
    echo "$signup"
  fi
}

extract() {
  local json="$1"
  local field="$2"
  if command -v jq &> /dev/null; then
    echo "$json" | jq -r "$field"
  else
    # simple fallback for token
    if [ "$field" = ".access_token" ]; then
      echo "$json" | grep -o '"access_token":"[^"]*' | sed 's/"access_token":"//' 
    elif [ "$field" = ".user.id" ]; then
      echo "$json" | grep -o '"id":"[^"]*' | head -1 | sed 's/"id":"//' 
    else
      echo ""
    fi
  fi
}

main() {
  echo "📦 Setting up 3 test users (Alice, Bob, Charlie)"

  if ! load_dev_vars; then
    exit 1
  fi

  if ! check_required_vars; then
    exit 1
  fi

  # Process Alice
  IFS='|' read -r email username display <<< "${USERS[0]}"
  echo ""
  echo "👤 Creating/getting token for $display ($email)"
  resp=$(create_or_get_token "$email" "$DEFAULT_PASSWORD")
  ALICE_TOKEN=$(extract "$resp" ".access_token")
  ALICE_ID=$(extract "$resp" ".user.id")
  if [ -z "$ALICE_TOKEN" ] || [ "$ALICE_TOKEN" = "null" ]; then
    echo "❌ Failed to get token for $email"
    exit 1
  fi
  echo "   → Setting username to '$username'"
  curl -s -X PATCH "$API_URL/api/users/profile" \
    -H "Authorization: Bearer $ALICE_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"$username\"}" >/dev/null || true

  # Process Bob
  IFS='|' read -r email username display <<< "${USERS[1]}"
  echo ""
  echo "👤 Creating/getting token for $display ($email)"
  resp=$(create_or_get_token "$email" "$DEFAULT_PASSWORD")
  BOB_TOKEN=$(extract "$resp" ".access_token")
  BOB_ID=$(extract "$resp" ".user.id")
  if [ -z "$BOB_TOKEN" ] || [ "$BOB_TOKEN" = "null" ]; then
    echo "❌ Failed to get token for $email"
    exit 1
  fi
  echo "   → Setting username to '$username'"
  curl -s -X PATCH "$API_URL/api/users/profile" \
    -H "Authorization: Bearer $BOB_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"$username\"}" >/dev/null || true

  # Process Charlie
  IFS='|' read -r email username display <<< "${USERS[2]}"
  echo ""
  echo "👤 Creating/getting token for $display ($email)"
  resp=$(create_or_get_token "$email" "$DEFAULT_PASSWORD")
  CHARLIE_TOKEN=$(extract "$resp" ".access_token")
  CHARLIE_ID=$(extract "$resp" ".user.id")
  if [ -z "$CHARLIE_TOKEN" ] || [ "$CHARLIE_TOKEN" = "null" ]; then
    echo "❌ Failed to get token for $email"
    exit 1
  fi
  echo "   → Setting username to '$username'"
  curl -s -X PATCH "$API_URL/api/users/profile" \
    -H "Authorization: Bearer $CHARLIE_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"$username\"}" >/dev/null || true

  # Save tokens to a temp file to source per-user
  ENV_FILE="/tmp/pakkt-multi-auth.sh"
  cat > "$ENV_FILE" << EOF
export ALICE_TOKEN="$ALICE_TOKEN"
export BOB_TOKEN="$BOB_TOKEN"
export CHARLIE_TOKEN="$CHARLIE_TOKEN"
export ALICE_ID="$ALICE_ID"
export BOB_ID="$BOB_ID"
export CHARLIE_ID="$CHARLIE_ID"
EOF

  echo ""
  echo "✅ Test users ready!"
  echo "Saved tokens: $ENV_FILE"
  echo "Source them with: source $ENV_FILE"
  echo ""
  echo "Alice: $ALICE_ID"
  echo "Bob:   $BOB_ID"
  echo "Charlie: $CHARLIE_ID"
}

main "$@"

