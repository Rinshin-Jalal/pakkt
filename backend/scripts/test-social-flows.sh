#!/bin/bash

# Pakkt API - Multi-User Social Dynamics Tests
# Uses 3 users to test packs, goals, check-ins, reactions, comments, and fines voting

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/load-env.sh"

API_URL="${API_URL:-http://localhost:8787}"

require_tokens() {
  if [ -z "$ALICE_TOKEN" ] || [ -z "$BOB_TOKEN" ] || [ -z "$CHARLIE_TOKEN" ]; then
    echo "❌ Missing ALICE_TOKEN/BOB_TOKEN/CHARLIE_TOKEN"
    echo "Run and source: ./scripts/setup-test-users.sh"
    echo "Then: source /tmp/pakkt-multi-auth.sh"
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
get_field() { echo "$2" | jq -r ".data.$1"; }

log() { echo -e "\n$1"; }

main() {
  require_tokens

  # Alice creates a pack
  log "👤 Alice creates pack"
  pack_body='{"name":"Morning Runners '$(date +%s)'","goal_type":"fitness"}'
  resp=$(api_call "$ALICE_TOKEN" POST "/api/packs" "$pack_body")
  status=$(parse_status "$resp"); body=$(parse_body "$resp")
  if [ "$status" != "201" ]; then echo "$body"; exit 1; fi
  pack_id=$(echo "$body" | jq -r ".data.id")
  echo "Pack: $pack_id"

  log "🎟️ Alice creates invite code"
  invite_body='{"max_uses":10,"expires_in_hours":24}'
  resp=$(api_call "$ALICE_TOKEN" POST "/api/packs/$pack_id/invite-codes" "$invite_body")
  status=$(parse_status "$resp"); body=$(parse_body "$resp")
  if [ "$status" != "201" ]; then echo "$body"; exit 1; fi
  invite_code=$(echo "$body" | jq -r ".data.code")
  echo "Invite code: $invite_code"

  log "➕ Bob joins using invite code"
  use_code_b='{"code":"'$invite_code'"}'
  resp=$(api_call "$BOB_TOKEN" POST "/api/invite-codes/use" "$use_code_b")
  status=$(parse_status "$resp"); if [ "$status" != "201" ]; then echo "$resp"; exit 1; fi

  log "➕ Charlie joins using invite code"
  use_code_c='{"code":"'$invite_code'"}'
  resp=$(api_call "$CHARLIE_TOKEN" POST "/api/invite-codes/use" "$use_code_c")
  status=$(parse_status "$resp"); if [ "$status" != "201" ]; then echo "$resp"; exit 1; fi

  # Alice creates a pack-wide goal
  log "🎯 Alice creates pack-wide goal"
  goal='{"title":"5km Run by 8am","description":"Daily run","goal_type":"pack","recurrence_rule":{"type":"daily","interval":1},"check_in_time":"08:00","proof_required":true,"fine_amount":5}'
  resp=$(api_call "$ALICE_TOKEN" POST "/api/packs/$pack_id/goals" "$goal")
  status=$(parse_status "$resp"); body=$(parse_body "$resp")
  if [ "$status" != "201" ]; then echo "$body"; exit 1; fi
  goal_id=$(echo "$body" | jq -r ".data.id")
  echo "Goal: $goal_id"

  # Alice check-in success
  log "✅ Alice checks in"
  checkin_a='{"goal_id":"'$goal_id'","proof_url":"https://example.com/proof-alice.jpg","caption":"Great start!"}'
  resp=$(api_call "$ALICE_TOKEN" POST "/api/checkins" "$checkin_a")
  status=$(parse_status "$resp"); if [ "$status" != "201" ]; then echo "$resp"; exit 1; fi
  alice_checkin_id=$(parse_body "$resp" | jq -r ".data.id")

  # Bob check-in success
  log "✅ Bob checks in"
  checkin_b='{"goal_id":"'$goal_id'","proof_url":"https://example.com/proof-bob.jpg","caption":"Nice run!"}'
  resp=$(api_call "$BOB_TOKEN" POST "/api/checkins" "$checkin_b")
  status=$(parse_status "$resp"); if [ "$status" != "201" ]; then echo "$resp"; exit 1; fi
  bob_checkin_id=$(parse_body "$resp" | jq -r ".data.id")

  # Validate pack stats after check-ins
  log "📊 Validating pack stats"
  resp=$(api_call "$ALICE_TOKEN" GET "/api/packs/$pack_id/stats")
  status=$(parse_status "$resp"); body=$(parse_body "$resp")
  if [ "$status" != "200" ]; then echo "$body"; exit 1; fi

  total_xp=$(echo "$body" | jq -r ".data.total_xp")
  member_count=$(echo "$body" | jq -r ".data.member_count")
  pack_level=$(echo "$body" | jq -r ".data.level")

  echo "Pack Stats - XP: $total_xp, Members: $member_count, Level: $pack_level"

  if [ "$member_count" != "3" ]; then
    echo "❌ Expected 3 members, got $member_count"
    exit 1
  fi

  if [ "$total_xp" -le "0" ]; then
    echo "❌ Expected positive XP, got $total_xp"
    exit 1
  fi

  echo "✅ Pack stats validated"

  # Charlie misses: create fine targeting Charlie
  log "⚖️ Alice creates fine for Charlie missing"
  fine='{"user_id":"'$CHARLIE_ID'","goal_id":"'$goal_id'","reason":"Missed 8am run"}'
  resp=$(api_call "$ALICE_TOKEN" POST "/api/fines" "$fine")
  status=$(parse_status "$resp"); body=$(parse_body "$resp")
  if [ "$status" != "201" ]; then echo "$body"; exit 1; fi
  fine_id=$(echo "$body" | jq -r ".data.id")
  echo "Fine: $fine_id"

  # Votes: Alice enforce, Bob dismiss, Charlie cannot vote on own fine
  log "🗳️ Alice votes ENFORCE"
  v1='{"vote":true}'
  resp=$(api_call "$ALICE_TOKEN" POST "/api/fines/$fine_id/vote" "$v1")
  status=$(parse_status "$resp"); if [ "$status" != "201" ]; then echo "$resp"; exit 1; fi

  log "🗳️ Bob votes DISMISS"
  v2='{"vote":false}'
  resp=$(api_call "$BOB_TOKEN" POST "/api/fines/$fine_id/vote" "$v2")
  status=$(parse_status "$resp"); if [ "$status" != "201" ]; then echo "$resp"; exit 1; fi

  log "🚫 Charlie tries to vote (should fail)"
  v3='{"vote":true}'
  resp=$(api_call "$CHARLIE_TOKEN" POST "/api/fines/$fine_id/vote" "$v3")
  status=$(parse_status "$resp")
  if [ "$status" = "201" ]; then echo "Expected failure for self-vote"; exit 1; fi

  # Reactions/comments across users on Bob's check-in
  log "💬 Social: Alice reacts and comments on Bob's check-in"
  r1='{"check_in_id":"'$bob_checkin_id'","emoji":"🔥"}'
  c1='{"check_in_id":"'$bob_checkin_id'","content":"LETS GO"}'
  api_call "$ALICE_TOKEN" POST "/api/social/reactions" "$r1" >/dev/null
  api_call "$ALICE_TOKEN" POST "/api/social/comments" "$c1" >/dev/null

  log "💬 Social: Charlie reacts and comments"
  r2='{"check_in_id":"'$bob_checkin_id'","emoji":"💪"}'
  c2='{"check_in_id":"'$bob_checkin_id'","content":"Tomorrow I will join"}'
  api_call "$CHARLIE_TOKEN" POST "/api/social/reactions" "$r2" >/dev/null
  api_call "$CHARLIE_TOKEN" POST "/api/social/comments" "$c2" >/dev/null

  # Fetch feed events for each user
  log "📰 Fetch feed events for all"
  api_call "$ALICE_TOKEN" GET "/api/social/feed-events?limit=10" >/dev/null
  api_call "$BOB_TOKEN" GET "/api/social/feed-events?limit=10" >/dev/null
  api_call "$CHARLIE_TOKEN" GET "/api/social/feed-events?limit=10" >/dev/null

  # Resolve fine (tie -> pending unless closed). Force resolve to see outcome
  log "🧮 Resolve fine after votes"
  resp=$(api_call "$ALICE_TOKEN" POST "/api/fines/$fine_id/resolve")
  status=$(parse_status "$resp"); body=$(parse_body "$resp")
  if [ "$status" != "200" ]; then echo "$body"; exit 1; fi
  consensus=$(echo "$body" | jq -r ".data.status")
  echo "Fine status: $consensus"

  echo "\n✅ Multi-user social flows completed"
  echo "Pack: $pack_id"
  echo "Invite code: $invite_code"
  echo "Goal: $goal_id"
  echo "Alice check-in: $alice_checkin_id"
  echo "Bob check-in: $bob_checkin_id"
  echo "Fine: $fine_id"
}

main "$@"

