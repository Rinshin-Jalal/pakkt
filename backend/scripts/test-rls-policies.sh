#!/bin/bash

# Test RLS Policies - Verify security policies are enforced
# Tests that should FAIL if RLS is working correctly

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/load-env.sh"

API_URL="${API_URL:-http://localhost:8787}"

require_tokens() {
  if [ -z "$ALICE_TOKEN" ] || [ -z "$BOB_TOKEN" ]; then
    echo "❌ Missing ALICE_TOKEN/BOB_TOKEN"
    echo "Run: ./scripts/setup-test-users.sh"
    exit 1
  fi
}

api_call() {
  local token="$1"; shift
  local method="$1"; shift
  local endpoint="$1"; shift
  local data="$1"; shift || true

  if [ -n "$data" ]; then
    curl -s -w "\n%{http_code}" -X "$method" "$API_URL$endpoint" \
      -H "Authorization: Bearer $token" \
      -H "Content-Type: application/json" \
      -d "$data"
  else
    curl -s -w "\n%{http_code}" -X "$method" "$API_URL$endpoint" \
      -H "Authorization: Bearer $token"
  fi
}

parse_status() { echo "$1" | tail -n 1; }
parse_body() { echo "$1" | sed '$d'; }

log_test() {
  echo ""
  echo "🧪 TEST: $1"
}

log_pass() {
  echo "✅ PASS: $1"
}

log_fail() {
  echo "❌ FAIL: $1"
  exit 1
}

main() {
  require_tokens

  echo "============================================"
  echo "RLS POLICY SECURITY TESTS"
  echo "============================================"

  # Setup: Alice creates pack and invite code
  log_test "Setup: Alice creates pack"
  pack_body='{"name":"RLS Test Pack '$(date +%s)'","goal_type":"test"}'
  resp=$(api_call "$ALICE_TOKEN" POST "/api/packs" "$pack_body")
  status=$(parse_status "$resp")
  if [ "$status" != "201" ]; then
    log_fail "Failed to create pack"
  fi
  pack_id=$(parse_body "$resp" | jq -r ".data.id")
  echo "Pack ID: $pack_id"

  log_test "Setup: Alice creates invite code"
  invite_body='{"max_uses":5,"expires_in_hours":24}'
  resp=$(api_call "$ALICE_TOKEN" POST "/api/packs/$pack_id/invite-codes" "$invite_body")
  status=$(parse_status "$resp")
  if [ "$status" != "201" ]; then
    log_fail "Failed to create invite code"
  fi
  invite_code=$(parse_body "$resp" | jq -r ".data.code")
  echo "Invite Code: $invite_code"

  log_test "Setup: Bob joins pack using invite code"
  use_code='{"code":"'$invite_code'"}'
  resp=$(api_call "$BOB_TOKEN" POST "/api/invite-codes/use" "$use_code")
  status=$(parse_status "$resp")
  if [ "$status" != "201" ]; then
    log_fail "Bob failed to join pack"
  fi

  log_test "Setup: Alice creates goal"
  goal_body='{"title":"Test Goal","goal_type":"pack","recurrence_rule":{"type":"daily","interval":1},"fine_amount":5}'
  resp=$(api_call "$ALICE_TOKEN" POST "/api/packs/$pack_id/goals" "$goal_body")
  status=$(parse_status "$resp")
  if [ "$status" != "201" ]; then
    log_fail "Failed to create goal"
  fi
  goal_id=$(parse_body "$resp" | jq -r ".data.id")
  echo "Goal ID: $goal_id"

  # ========================================================================
  # RLS TEST 1: Pack members can create fines (should SUCCEED)
  # ========================================================================
  log_test "Bob creates fine for Alice (should SUCCEED - pack member)"
  fine_body='{"user_id":"'$ALICE_ID'","goal_id":"'$goal_id'","reason":"Test fine"}'
  resp=$(api_call "$BOB_TOKEN" POST "/api/fines" "$fine_body")
  status=$(parse_status "$resp")
  if [ "$status" = "201" ]; then
    log_pass "Bob can create fine (RLS allows pack members)"
    fine_id=$(parse_body "$resp" | jq -r ".data.id")
  else
    log_fail "Bob should be able to create fine as pack member"
  fi

  # ========================================================================
  # RLS TEST 2: Users can vote on fines (should SUCCEED)
  # ========================================================================
  log_test "Bob votes on fine (should SUCCEED - pack member, not fined user)"
  vote_body='{"vote":true}'
  resp=$(api_call "$BOB_TOKEN" POST "/api/fines/$fine_id/vote" "$vote_body")
  status=$(parse_status "$resp")
  if [ "$status" = "201" ]; then
    log_pass "Bob can vote (RLS allows pack members)"
  else
    log_fail "Bob should be able to vote as pack member"
  fi

  # ========================================================================
  # RLS TEST 3: Duplicate vote prevention (should FAIL with 409)
  # ========================================================================
  log_test "Bob tries to vote again (should FAIL - unique constraint)"
  resp=$(api_call "$BOB_TOKEN" POST "/api/fines/$fine_id/vote" "$vote_body")
  status=$(parse_status "$resp")
  if [ "$status" = "409" ] || [ "$status" = "400" ]; then
    log_pass "Duplicate vote prevented (unique constraint working)"
  else
    log_fail "Duplicate vote should be prevented (got status $status)"
  fi

  # ========================================================================
  # RLS TEST 4: Pack members can resolve fines (should SUCCEED)
  # ========================================================================
  log_test "Bob resolves fine (should SUCCEED - pack member)"
  resp=$(api_call "$BOB_TOKEN" POST "/api/fines/$fine_id/resolve")
  status=$(parse_status "$resp")
  if [ "$status" = "200" ]; then
    log_pass "Bob can resolve fine (RLS allows pack members)"
  else
    log_fail "Bob should be able to resolve fine as pack member"
  fi

  # ========================================================================
  # RLS TEST 5: Check-in creates and updates XP (should SUCCEED)
  # ========================================================================
  log_test "Alice checks in (should SUCCEED and update her XP)"
  checkin_body='{"goal_id":"'$goal_id'","proof_url":"https://example.com/proof.jpg"}'
  resp=$(api_call "$ALICE_TOKEN" POST "/api/checkins" "$checkin_body")
  status=$(parse_status "$resp")
  if [ "$status" = "201" ]; then
    log_pass "Alice check-in succeeded (RLS allows self XP update)"
  else
    body=$(parse_body "$resp")
    echo "Response: $body"
    log_fail "Alice should be able to check in and update her own XP"
  fi

  # ========================================================================
  # RLS TEST 6: Validate invite code (should SUCCEED - anyone can read active codes)
  # ========================================================================
  log_test "Bob validates invite code (should SUCCEED - public read for active codes)"
  resp=$(api_call "$BOB_TOKEN" GET "/api/invite-codes/$invite_code/validate")
  status=$(parse_status "$resp")
  if [ "$status" = "200" ]; then
    log_pass "Invite code validation works (RLS allows reading active codes)"
  else
    log_fail "Should be able to validate invite codes"
  fi

  # ========================================================================
  # RLS TEST 7: Only creator can deactivate invite codes (should FAIL for Bob)
  # ========================================================================
  log_test "Setup: Alice creates another invite code for deactivation test"
  resp=$(api_call "$ALICE_TOKEN" POST "/api/packs/$pack_id/invite-codes" "$invite_body")
  status=$(parse_status "$resp")
  if [ "$status" != "201" ]; then
    log_fail "Failed to create second invite code"
  fi
  code_id=$(parse_body "$resp" | jq -r ".data.id")

  log_test "Bob tries to deactivate Alice's invite code (should FAIL - not creator)"
  resp=$(api_call "$BOB_TOKEN" PATCH "/api/packs/$pack_id/invite-codes/$code_id/deactivate")
  status=$(parse_status "$resp")
  if [ "$status" = "403" ] || [ "$status" = "404" ]; then
    log_pass "Bob cannot deactivate Alice's invite code (authorization working)"
  else
    log_fail "Bob should NOT be able to deactivate invite code (got status $status)"
  fi

  echo ""
  echo "============================================"
  echo "✅ ALL RLS POLICY TESTS PASSED"
  echo "============================================"
  echo ""
  echo "Summary:"
  echo "  ✓ Pack members can create fines"
  echo "  ✓ Pack members can vote on fines"
  echo "  ✓ Duplicate votes prevented by unique constraint"
  echo "  ✓ Pack members can resolve fines"
  echo "  ✓ Users can update their own XP via check-ins"
  echo "  ✓ Active invite codes are publicly readable"
  echo "  ✓ Only pack creator can manage invite codes"
  echo ""
}

main "$@"
