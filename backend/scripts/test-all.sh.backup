#!/bin/bash

# 🧪 Pakkt API - Complete Test Suite
# Tests all endpoints and critical flows

set -e

# Load environment variables from .dev.vars
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/load-env.sh"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Load environment variables
if ! load_dev_vars; then
    exit 1
fi

# Configuration
API_BASE="${API_BASE:-http://localhost:8787}"
TOKEN="${AUTH_TOKEN:-}"

# Test results
PASSED=0
FAILED=0
TOTAL=0

# Helper functions
log_test() {
    echo -e "${BLUE}[TEST]${NC} $1"
    ((TOTAL++))
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
    ((PASSED++))
}

log_failure() {
    echo -e "${RED}[✗]${NC} $1"
    ((FAILED++))
}

log_info() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

# Check dependencies
check_dependencies() {
    log_info "Checking dependencies..."
    
    if ! command -v curl &> /dev/null; then
        echo "Error: curl is required"
        exit 1
    fi
    
    if ! command -v jq &> /dev/null; then
        echo "Error: jq is required (brew install jq)"
        exit 1
    fi
    
    log_success "Dependencies OK"
}

# Check server is running
check_server() {
    log_info "Checking server at $API_BASE..."
    
    RESPONSE=$(curl -s -w "\n%{http_code}" "$API_BASE/health")
    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    BODY=$(echo "$RESPONSE" | sed '$d')
    
    if [ "$HTTP_CODE" = "200" ]; then
        log_success "Server is running"
        return 0
    else
        log_failure "Server not responding (HTTP $HTTP_CODE)"
        exit 1
    fi
}

# Check auth token
check_auth() {
    if [ -z "$TOKEN" ]; then
        log_failure "AUTH_TOKEN environment variable not set"
        echo ""
        echo "Please get a token first:"
        echo "  ./scripts/get-auth-token.sh"
        echo ""
        echo "Or set manually:"
        echo "  export AUTH_TOKEN='your-jwt-token'"
        exit 1
    fi
    
    log_info "Testing authentication..."
    RESPONSE=$(curl -s -w "\n%{http_code}" -H "Authorization: Bearer $TOKEN" "$API_BASE/api/me")
    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    
    if [ "$HTTP_CODE" = "200" ]; then
        USER_ID=$(echo "$RESPONSE" | sed '$d' | jq -r '.data.userId')
        log_success "Authentication OK (User: $USER_ID)"
        return 0
    else
        log_failure "Authentication failed (HTTP $HTTP_CODE)"
        echo "$RESPONSE" | sed '$d' | jq '.'
        exit 1
    fi
}

# Test endpoint
test_endpoint() {
    local METHOD=$1
    local PATH=$2
    local DATA=$3
    local EXPECTED_CODE=$4
    local DESCRIPTION=$5
    
    log_test "$DESCRIPTION"
    
    if [ -n "$DATA" ]; then
        RESPONSE=$(curl -s -w "\n%{http_code}" -X "$METHOD" \
            -H "Authorization: Bearer $TOKEN" \
            -H "Content-Type: application/json" \
            -d "$DATA" \
            "$API_BASE$PATH")
    else
        RESPONSE=$(curl -s -w "\n%{http_code}" -X "$METHOD" \
            -H "Authorization: Bearer $TOKEN" \
            "$API_BASE$PATH")
    fi
    
    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    BODY=$(echo "$RESPONSE" | sed '$d')
    
    if [ "$HTTP_CODE" = "$EXPECTED_CODE" ]; then
        log_success "$DESCRIPTION (HTTP $HTTP_CODE)"
        echo "$BODY"
        return 0
    else
        log_failure "$DESCRIPTION (Expected $EXPECTED_CODE, got $HTTP_CODE)"
        echo "$BODY" | jq '.' 2>/dev/null || echo "$BODY"
        return 1
    fi
}

# Main test suite
echo ""
echo "╔════════════════════════════════════════╗"
echo "║   🧪 Pakkt API Test Suite              ║"
echo "╔════════════════════════════════════════╗"
echo ""

# Prerequisites
check_dependencies
check_server
check_auth

echo ""
echo "════════════════════════════════════════"
echo "  👤 Users Feature Tests"
echo "════════════════════════════════════════"

# Get profile
PROFILE_RESPONSE=$(test_endpoint "GET" "/api/users/profile" "" "200" "Get user profile")
if [ $? -eq 0 ]; then
    echo "$PROFILE_RESPONSE" | jq '.' > /dev/null 2>&1
fi

# Update profile
UPDATE_DATA='{"username":"testuser","bio":"Test bio from automated tests"}'
test_endpoint "PATCH" "/api/users/profile" "$UPDATE_DATA" "200" "Update user profile"

echo ""
echo "════════════════════════════════════════"
echo "  📦 Packs Feature Tests"
echo "════════════════════════════════════════"

# Create pack
PACK_DATA='{"name":"Test Pack '$(date +%s)'","description":"Automated test pack","visibility":"private"}'
PACK_RESPONSE=$(test_endpoint "POST" "/api/packs" "$PACK_DATA" "201" "Create pack")
if [ $? -eq 0 ]; then
    PACK_ID=$(echo "$PACK_RESPONSE" | jq -r '.data.id')
    log_info "Pack ID: $PACK_ID"
    
    # Get pack
    test_endpoint "GET" "/api/packs/$PACK_ID" "" "200" "Get pack details"
    
    # Update pack
    UPDATE_PACK_DATA='{"name":"Updated Test Pack","description":"Updated description"}'
    test_endpoint "PATCH" "/api/packs/$PACK_ID" "$UPDATE_PACK_DATA" "200" "Update pack"
    
    # Get pack stats
    test_endpoint "GET" "/api/packs/$PACK_ID/stats" "" "200" "Get pack stats"
fi

# List packs
test_endpoint "GET" "/api/packs" "" "200" "List user packs"

echo ""
echo "════════════════════════════════════════"
echo "  🎯 Goals Feature Tests"
echo "════════════════════════════════════════"

if [ -n "$PACK_ID" ]; then
    # Create goal
    GOAL_DATA='{"title":"Test Goal '$(date +%s)'","description":"Automated test goal","recurrence_pattern":"daily","check_in_time":"09:00","requires_proof":false}'
    GOAL_RESPONSE=$(test_endpoint "POST" "/api/packs/$PACK_ID/goals" "$GOAL_DATA" "201" "Create goal")
    
    if [ $? -eq 0 ]; then
        GOAL_ID=$(echo "$GOAL_RESPONSE" | jq -r '.data.id')
        log_info "Goal ID: $GOAL_ID"
        
        # Get goal
        test_endpoint "GET" "/api/goals/$GOAL_ID" "" "200" "Get goal details"
        
        # Update goal
        UPDATE_GOAL_DATA='{"title":"Updated Test Goal"}'
        test_endpoint "PATCH" "/api/goals/$GOAL_ID" "$UPDATE_GOAL_DATA" "200" "Update goal"
        
        # Toggle goal
        test_endpoint "POST" "/api/goals/$GOAL_ID/toggle" "" "200" "Toggle goal active status"
    fi
    
    # List pack goals
    test_endpoint "GET" "/api/packs/$PACK_ID/goals" "" "200" "List pack goals"
fi

echo ""
echo "════════════════════════════════════════"
echo "  ✅ Check-ins Feature Tests"
echo "════════════════════════════════════════"

if [ -n "$GOAL_ID" ]; then
    # Submit check-in
    CHECKIN_DATA='{"goal_id":"'$GOAL_ID'","caption":"Automated test check-in","visibility":"pack"}'
    CHECKIN_RESPONSE=$(test_endpoint "POST" "/api/checkins" "$CHECKIN_DATA" "201" "Submit check-in")
    
    if [ $? -eq 0 ]; then
        CHECKIN_ID=$(echo "$CHECKIN_RESPONSE" | jq -r '.data.id')
        log_info "Check-in ID: $CHECKIN_ID"
        
        # Get check-in
        test_endpoint "GET" "/api/checkins/$CHECKIN_ID" "" "200" "Get check-in details"
    fi
    
    # List check-ins
    test_endpoint "GET" "/api/checkins" "" "200" "List user check-ins"
    
    # Get streaks
    test_endpoint "GET" "/api/checkins/streaks" "" "200" "Get user streaks"
    
    if [ -n "$PACK_ID" ]; then
        # Get pack feed
        test_endpoint "GET" "/api/packs/$PACK_ID/checkins" "" "200" "Get pack check-ins feed"
    fi
fi

echo ""
echo "════════════════════════════════════════"
echo "  💰 Fines Feature Tests"
echo "════════════════════════════════════════"

if [ -n "$PACK_ID" ] && [ -n "$GOAL_ID" ]; then
    # Create fine
    FINE_DATA='{"pack_id":"'$PACK_ID'","goal_id":"'$GOAL_ID'","amount":500,"reason":"Automated test fine"}'
    FINE_RESPONSE=$(test_endpoint "POST" "/api/fines" "$FINE_DATA" "201" "Create fine")
    
    if [ $? -eq 0 ]; then
        FINE_ID=$(echo "$FINE_RESPONSE" | jq -r '.data.id')
        log_info "Fine ID: $FINE_ID"
        
        # Get fine
        test_endpoint "GET" "/api/fines/$FINE_ID" "" "200" "Get fine details"
        
        # Vote on fine
        VOTE_DATA='{"vote":true}'
        test_endpoint "POST" "/api/fines/$FINE_ID/vote" "$VOTE_DATA" "200" "Vote on fine (enforce)"
        
        # Appeal fine
        APPEAL_DATA='{"reason":"Testing appeal system"}'
        test_endpoint "POST" "/api/fines/$FINE_ID/appeal" "$APPEAL_DATA" "200" "Appeal fine"
    fi
    
    # List pack fines
    test_endpoint "GET" "/api/packs/$PACK_ID/fines" "" "200" "List pack fines"
fi

echo ""
echo "════════════════════════════════════════"
echo "  😀 Social Feature Tests"
echo "════════════════════════════════════════"

if [ -n "$CHECKIN_ID" ]; then
    # Add reaction
    REACTION_DATA='{"check_in_id":"'$CHECKIN_ID'","emoji":"🔥"}'
    REACTION_RESPONSE=$(test_endpoint "POST" "/api/social/reactions" "$REACTION_DATA" "201" "Add reaction")
    
    if [ $? -eq 0 ]; then
        REACTION_ID=$(echo "$REACTION_RESPONSE" | jq -r '.data.id')
        log_info "Reaction ID: $REACTION_ID"
    fi
    
    # Get reactions
    test_endpoint "GET" "/api/checkins/$CHECKIN_ID/reactions" "" "200" "Get check-in reactions"
    
    # Add comment
    COMMENT_DATA='{"check_in_id":"'$CHECKIN_ID'","content":"Great job! Automated test comment."}'
    COMMENT_RESPONSE=$(test_endpoint "POST" "/api/social/comments" "$COMMENT_DATA" "201" "Add comment")
    
    if [ $? -eq 0 ]; then
        COMMENT_ID=$(echo "$COMMENT_RESPONSE" | jq -r '.data.id')
        log_info "Comment ID: $COMMENT_ID"
        
        # Edit comment (within 5 min window)
        EDIT_COMMENT_DATA='{"content":"Updated: Amazing job!"}'
        test_endpoint "PATCH" "/api/social/comments/$COMMENT_ID" "$EDIT_COMMENT_DATA" "200" "Edit comment"
    fi
    
    # Get comments
    test_endpoint "GET" "/api/checkins/$CHECKIN_ID/comments" "" "200" "Get check-in comments"
fi

# Get feed events
test_endpoint "GET" "/api/social/feed-events" "" "200" "Get feed events"

echo ""
echo "════════════════════════════════════════"
echo "  📤 Uploads Feature Tests"
echo "════════════════════════════════════════"

if [ -n "$PACK_ID" ]; then
    # Request presigned URL
    UPLOAD_DATA='{"file_type":"image/jpeg","purpose":"checkin","pack_id":"'$PACK_ID'"}'
    UPLOAD_RESPONSE=$(test_endpoint "POST" "/api/uploads/presigned-url" "$UPLOAD_DATA" "201" "Request presigned URL")
    
    if [ $? -eq 0 ]; then
        FILE_KEY=$(echo "$UPLOAD_RESPONSE" | jq -r '.data.key')
        log_info "File key: $FILE_KEY"
    fi
fi

# Get upload history
test_endpoint "GET" "/api/uploads/history" "" "200" "Get upload history"

# Get upload stats
test_endpoint "GET" "/api/uploads/stats" "" "200" "Get upload stats"

echo ""
echo "════════════════════════════════════════"
echo "  🔒 Error Handling Tests"
echo "════════════════════════════════════════"

# Test unauthorized (no token)
log_test "Unauthorized request (no token)"
RESPONSE=$(curl -s -w "\n%{http_code}" "$API_BASE/api/users/profile")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
if [ "$HTTP_CODE" = "401" ]; then
    log_success "Unauthorized request returns 401"
    ((PASSED++))
else
    log_failure "Expected 401, got $HTTP_CODE"
    ((FAILED++))
fi
((TOTAL++))

# Test not found
log_test "Not found error (invalid ID)"
RESPONSE=$(curl -s -w "\n%{http_code}" -H "Authorization: Bearer $TOKEN" "$API_BASE/api/goals/00000000-0000-0000-0000-000000000000")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
if [ "$HTTP_CODE" = "404" ]; then
    log_success "Not found returns 404"
    ((PASSED++))
else
    log_failure "Expected 404, got $HTTP_CODE"
    ((FAILED++))
fi
((TOTAL++))

# Test validation error
log_test "Validation error (invalid data)"
INVALID_DATA='{"title":""}'
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "$INVALID_DATA" \
    "$API_BASE/api/packs")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
if [ "$HTTP_CODE" = "400" ]; then
    log_success "Validation error returns 400"
    ((PASSED++))
else
    log_failure "Expected 400, got $HTTP_CODE"
    ((FAILED++))
fi
((TOTAL++))

echo ""
echo "════════════════════════════════════════"
echo "  📊 Test Results"
echo "════════════════════════════════════════"
echo ""
echo "Total Tests:  $TOTAL"
echo -e "${GREEN}Passed:       $PASSED${NC}"
echo -e "${RED}Failed:       $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║   ✅ All Tests Passed! 🎉              ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    exit 0
else
    PERCENTAGE=$((PASSED * 100 / TOTAL))
    echo -e "${YELLOW}╔════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║   ⚠️  Some Tests Failed ($PERCENTAGE% passed)    ║${NC}"
    echo -e "${YELLOW}╚════════════════════════════════════════╝${NC}"
    exit 1
fi
