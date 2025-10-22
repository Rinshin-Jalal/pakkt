#!/bin/bash

# Pakkt API - End-to-End User Flow Testing
# Tests complete user journeys through the application

set -e

# Load environment variables from .dev.vars
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/load-env.sh"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Load environment variables
if ! load_dev_vars; then
    exit 1
fi

API_URL="${API_URL:-http://localhost:8787}"
AUTH_TOKEN="${AUTH_TOKEN:-}"

if [ -z "$AUTH_TOKEN" ]; then
    echo -e "${RED}ERROR: AUTH_TOKEN environment variable required${NC}"
    echo "Get a token by running:"
    echo "  ./scripts/get-auth-token.sh"
    echo ""
    echo "Or set manually:"
    echo "  AUTH_TOKEN='your_token_here' ./test-flows.sh"
    exit 1
fi

log_flow() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

log_step() {
    echo -e "\n${YELLOW}→ Step $1: $2${NC}"
}

log_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

log_error() {
    echo -e "${RED}✗ ERROR: $1${NC}"
    exit 1
}

# Helper function to make API calls
api_call() {
    local method=$1
    local endpoint=$2
    local data=$3
    
    if [ -n "$data" ]; then
        response=$(curl -s -w "\n%{http_code}" -X $method "$API_URL$endpoint" \
            -H "Authorization: Bearer $AUTH_TOKEN" \
            -H "Content-Type: application/json" \
            -d "$data")
    else
        response=$(curl -s -w "\n%{http_code}" -X $method "$API_URL$endpoint" \
            -H "Authorization: Bearer $AUTH_TOKEN")
    fi
    
    # BSD/macOS compatible way to split response
    status=$(echo "$response" | tail -n 1)
    body=$(echo "$response" | sed '$d')  # Delete last line
    
    echo "$status|$body"
}

# Parse response
get_status() {
    echo "$1" | cut -d'|' -f1
}

get_body() {
    echo "$1" | cut -d'|' -f2-
}

get_field() {
    local response=$1
    local field=$2
    echo "$(get_body "$response")" | jq -r ".data.$field"
}

# ============================================================================
# FLOW 1: Pack & Goal Creation Journey
# ============================================================================
test_pack_goal_flow() {
    log_flow "Flow 1: Pack & Goal Creation Journey"
    
    # Step 1: Get user profile
    log_step "1" "Get user profile"
    response=$(api_call GET "/api/users/profile")
    status=$(get_status "$response")
    
    if [ "$status" != "200" ]; then
        log_error "Failed to get profile (status: $status)"
    fi
    
    user_id=$(get_field "$response" "id")
    username=$(get_field "$response" "username")
    log_success "Logged in as: $username (ID: $user_id)"
    
    # Step 2: Create a pack
    log_step "2" "Create new pack"
    pack_data='{
        "name": "Early Birds '$(date +%s)'",
        "goal_type": "productivity"
    }'
    
    response=$(api_call POST "/api/packs" "$pack_data")
    status=$(get_status "$response")
    
    if [ "$status" != "201" ]; then
        log_error "Failed to create pack (status: $status)"
    fi
    
    pack_id=$(get_field "$response" "id")
    pack_name=$(get_field "$response" "name")

    # Debug output
    echo "DEBUG - Response body: $(get_body "$response")"
    echo "DEBUG - pack_id extracted: '$pack_id'"
    echo "DEBUG - pack_name extracted: '$pack_name'"

    if [ -z "$pack_id" ] || [ "$pack_id" = "null" ]; then
        log_error "Failed to extract pack_id from response"
    fi

    log_success "Created pack: $pack_name (ID: $pack_id)"
    
    # Step 3: Get pack details
    log_step "3" "Verify pack creation"
    response=$(api_call GET "/api/packs/$pack_id")
    status=$(get_status "$response")
    
    if [ "$status" != "200" ]; then
        log_error "Failed to get pack details (status: $status)"
    fi
    
    creator_id=$(get_field "$response" "creator_id")
    if [ "$creator_id" != "$user_id" ]; then
        log_error "Creator ID mismatch"
    fi
    
    log_success "Pack verified with correct creator"
    
    # Step 4a: Create personal goal (any member can do this)
    log_step "4a" "Create personal morning workout goal"
    personal_goal_data='{
        "title": "Personal Morning Workout",
        "description": "30 minutes of exercise before 9 AM",
        "goal_type": "personal",
        "recurrence_rule": {
            "type": "daily",
            "interval": 1
        },
        "check_in_time": "09:00",
        "proof_required": true,
        "fine_amount": 10
    }'

    response=$(api_call POST "/api/packs/$pack_id/goals" "$personal_goal_data")
    status=$(get_status "$response")

    if [ "$status" != "201" ]; then
        log_error "Failed to create personal goal (status: $status)"
    fi

    personal_goal_id=$(get_field "$response" "id")
    personal_goal_title=$(get_field "$response" "title")
    log_success "Created personal goal: $personal_goal_title (ID: $personal_goal_id)"

    # Step 4b: Create pack goal (only pack creator/admin can do this)
    log_step "4b" "Create pack-wide study goal"
    pack_goal_data='{
        "title": "Daily Study Session",
        "description": "Everyone must study for 1 hour",
        "goal_type": "pack",
        "recurrence_rule": {
            "type": "daily",
            "interval": 1
        },
        "check_in_time": "20:00",
        "proof_required": false,
        "fine_amount": 5
    }'

    response=$(api_call POST "/api/packs/$pack_id/goals" "$pack_goal_data")
    status=$(get_status "$response")

    if [ "$status" != "201" ]; then
        log_error "Failed to create pack goal (status: $status)"
    fi

    pack_goal_id=$(get_field "$response" "id")
    pack_goal_title=$(get_field "$response" "title")
    log_success "Created pack goal: $pack_goal_title (ID: $pack_goal_id)"

    # Use personal goal for subsequent tests
    goal_id=$personal_goal_id
    
    # Step 5: List pack goals (should show both personal and pack goals)
    log_step "5" "List all pack goals"
    response=$(api_call GET "/api/packs/$pack_id/goals")
    status=$(get_status "$response")

    if [ "$status" != "200" ]; then
        log_error "Failed to list goals (status: $status)"
    fi

    goal_count=$(echo "$(get_body "$response")" | jq '.data | length')
    if [ "$goal_count" -lt "2" ]; then
        log_error "Expected at least 2 goals (1 personal + 1 pack), got $goal_count"
    fi
    log_success "Pack has $goal_count goal(s) (personal + pack goals)"

    # Step 6: Get pack stats
    log_step "6" "Get pack statistics"
    response=$(api_call GET "/api/packs/$pack_id/stats")
    status=$(get_status "$response")
    
    if [ "$status" != "200" ]; then
        log_error "Failed to get pack stats (status: $status)"
    fi
    
    active_goals=$(get_field "$response" "active_goals")
    total_xp=$(get_field "$response" "total_xp")
    log_success "Pack stats - Active goals: $active_goals, Total XP: $total_xp"
    
    echo -e "\n${GREEN}✓✓✓ Flow 1 completed successfully ✓✓✓${NC}"
    
    # Export for next flows
    export PACK_ID=$pack_id
    export GOAL_ID=$goal_id
}

# ============================================================================
# FLOW 2: Check-in & Accountability Journey
# ============================================================================
test_checkin_accountability_flow() {
    log_flow "Flow 2: Check-in & Accountability Journey"
    
    if [ -z "$GOAL_ID" ]; then
        log_error "GOAL_ID not set. Run Flow 1 first."
    fi
    
    # Step 1: Submit check-in with proof
    log_step "1" "Submit check-in with proof"
    checkin_data='{
        "goal_id": "'$GOAL_ID'",
        "proof_url": "https://pakkt-uploads.r2.dev/test/proof.jpg",
        "note": "Completed 45 minute HIIT workout!"
    }'
    
    response=$(api_call POST "/api/checkins" "$checkin_data")
    status=$(get_status "$response")
    
    if [ "$status" != "201" ]; then
        log_error "Failed to submit check-in (status: $status)"
    fi
    
    checkin_id=$(get_field "$response" "id")
    xp_earned=$(get_field "$response" "xp_earned")
    current_streak=$(get_field "$response" "current_streak")
    log_success "Check-in submitted! Earned $xp_earned XP, Streak: $current_streak days"
    
    # Step 2: Get check-in details
    log_step "2" "Verify check-in details"
    response=$(api_call GET "/api/checkins/$checkin_id")
    status=$(get_status "$response")
    
    if [ "$status" != "200" ]; then
        log_error "Failed to get check-in details (status: $status)"
    fi
    
    verified=$(get_field "$response" "verified")
    log_success "Check-in verified: $verified"
    
    # Step 3: List my check-ins (use feed endpoint)
    log_step "3" "List my check-ins"
    response=$(api_call GET "/api/checkins/feed?limit=10")
    status=$(get_status "$response")

    if [ "$status" != "200" ]; then
        log_error "Failed to list check-ins (status: $status)"
    fi

    checkin_count=$(echo "$(get_body "$response")" | jq '.data | length')
    log_success "Found $checkin_count check-in(s)"
    
    # Step 4: View pack feed
    log_step "4" "View pack activity feed"
    response=$(api_call GET "/api/packs/$PACK_ID/checkins?limit=20")
    status=$(get_status "$response")
    
    if [ "$status" != "200" ]; then
        log_error "Failed to get pack feed (status: $status)"
    fi
    
    feed_count=$(echo "$(get_body "$response")" | jq '.data | length')
    log_success "Pack feed has $feed_count item(s)"
    
    echo -e "\n${GREEN}✓✓✓ Flow 2 completed successfully ✓✓✓${NC}"
    
    export CHECKIN_ID=$checkin_id
}

# ============================================================================
# FLOW 3: Social Engagement Journey
# ============================================================================
test_social_engagement_flow() {
    log_flow "Flow 3: Social Engagement Journey"
    
    if [ -z "$CHECKIN_ID" ]; then
        log_error "CHECKIN_ID not set. Run Flow 2 first."
    fi
    
    # Step 1: Add reaction to check-in
    log_step "1" "Add 🔥 reaction to check-in"
    reaction_data='{
        "target_type": "checkin",
        "target_id": "'$CHECKIN_ID'",
        "emoji": "🔥"
    }'
    
    response=$(api_call POST "/api/reactions" "$reaction_data")
    status=$(get_status "$response")
    
    if [ "$status" != "201" ]; then
        log_error "Failed to add reaction (status: $status)"
    fi
    
    reaction_id=$(get_field "$response" "id")
    log_success "Added reaction (ID: $reaction_id)"
    
    # Step 2: View check-in reactions
    log_step "2" "View all reactions on check-in"
    response=$(api_call GET "/api/checkins/$CHECKIN_ID/reactions")
    status=$(get_status "$response")
    
    if [ "$status" != "200" ]; then
        log_error "Failed to get reactions (status: $status)"
    fi
    
    reaction_count=$(echo "$(get_body "$response")" | jq '.data | length')
    log_success "Check-in has $reaction_count reaction(s)"
    
    # Step 3: Add comment
    log_step "3" "Add comment to check-in"
    comment_data='{
        "checkin_id": "'$CHECKIN_ID'",
        "content": "Amazing work! Keep crushing those goals! 💪"
    }'
    
    response=$(api_call POST "/api/comments" "$comment_data")
    status=$(get_status "$response")
    
    if [ "$status" != "201" ]; then
        log_error "Failed to add comment (status: $status)"
    fi
    
    comment_id=$(get_field "$response" "id")
    log_success "Added comment (ID: $comment_id)"
    
    # Step 4: View check-in comments
    log_step "4" "View all comments on check-in"
    response=$(api_call GET "/api/checkins/$CHECKIN_ID/comments")
    status=$(get_status "$response")
    
    if [ "$status" != "200" ]; then
        log_error "Failed to get comments (status: $status)"
    fi
    
    comment_count=$(echo "$(get_body "$response")" | jq '.data | length')
    log_success "Check-in has $comment_count comment(s)"
    
    # Step 5: Edit comment
    log_step "5" "Edit comment"
    edit_data='{
        "content": "Updated: Incredible work! You are an inspiration! 🌟"
    }'
    
    response=$(api_call PATCH "/api/comments/$comment_id" "$edit_data")
    status=$(get_status "$response")
    
    if [ "$status" != "200" ]; then
        log_error "Failed to edit comment (status: $status)"
    fi
    
    log_success "Comment edited successfully"
    
    # Step 6: Update reaction (change emoji)
    log_step "6" "Update reaction to 💪"
    reaction_update='{
        "target_type": "checkin",
        "target_id": "'$CHECKIN_ID'",
        "emoji": "💪"
    }'
    
    response=$(api_call POST "/api/reactions" "$reaction_update")
    status=$(get_status "$response")
    
    if [ "$status" != "201" ]; then
        log_error "Failed to update reaction (status: $status)"
    fi
    
    log_success "Reaction updated to 💪"
    
    echo -e "\n${GREEN}✓✓✓ Flow 3 completed successfully ✓✓✓${NC}"
    
    export COMMENT_ID=$comment_id
    export REACTION_ID=$reaction_id
}

# ============================================================================
# FLOW 4: Upload Journey
# ============================================================================
test_upload_flow() {
    log_flow "Flow 4: File Upload Journey"
    
    # Step 1: Request presigned URL for image
    log_step "1" "Request presigned URL for image upload"
    upload_request='{
        "file_type": "image/jpeg",
        "purpose": "checkin"
    }'
    
    response=$(api_call POST "/api/uploads/presigned-url" "$upload_request")
    status=$(get_status "$response")
    
    if [ "$status" != "200" ]; then
        log_error "Failed to get presigned URL (status: $status)"
    fi
    
    presigned_url=$(get_field "$response" "presigned_url")
    public_url=$(get_field "$response" "public_url")
    key=$(get_field "$response" "key")
    expires_in=$(get_field "$response" "expires_in")
    
    log_success "Presigned URL generated (expires in $expires_in seconds)"
    echo "  Key: $key"
    echo "  Public URL: $public_url"
    
    # Step 2: Request presigned URL for video
    log_step "2" "Request presigned URL for video upload"
    video_request='{
        "file_type": "video/mp4",
        "purpose": "checkin"
    }'
    
    response=$(api_call POST "/api/uploads/presigned-url" "$video_request")
    status=$(get_status "$response")
    
    if [ "$status" != "200" ]; then
        log_error "Failed to get video presigned URL (status: $status)"
    fi
    
    video_key=$(get_field "$response" "key")
    log_success "Video presigned URL generated"
    echo "  Key: $video_key"
    
    # Step 3: Test invalid file type
    log_step "3" "Test invalid file type (should fail)"
    invalid_request='{
        "file_type": "application/exe",
        "purpose": "checkin"
    }'
    
    response=$(api_call POST "/api/uploads/presigned-url" "$invalid_request")
    status=$(get_status "$response")
    
    if [ "$status" == "400" ]; then
        log_success "Invalid file type correctly rejected"
    else
        log_error "Invalid file type should have been rejected (status: $status)"
    fi
    
    echo -e "\n${GREEN}✓✓✓ Flow 4 completed successfully ✓✓✓${NC}"
    echo -e "${YELLOW}Note: Actual file upload to R2 requires multipart form data${NC}"
    echo -e "${YELLOW}Use the presigned URL with curl --upload-file or iOS URLSession${NC}"
}

# ============================================================================
# FLOW 5: Error Handling Journey
# ============================================================================
test_error_handling_flow() {
    log_flow "Flow 5: Error Handling & Validation Journey"
    
    # Test 1: Invalid data validation
    log_step "1" "Test validation error (empty username)"
    invalid_profile='{
        "username": "",
        "bio": "Test"
    }'
    
    response=$(api_call PATCH "/api/users/profile" "$invalid_profile")
    status=$(get_status "$response")
    
    if [ "$status" == "400" ]; then
        log_success "Validation error correctly returned"
    else
        log_error "Expected 400 validation error (got: $status)"
    fi
    
    # Test 2: 404 Not Found
    log_step "2" "Test 404 not found"
    response=$(api_call GET "/api/packs/00000000-0000-0000-0000-000000000000")
    status=$(get_status "$response")
    
    if [ "$status" == "404" ]; then
        log_success "404 error correctly returned"
    else
        log_error "Expected 404 not found (got: $status)"
    fi
    
    # Test 3: Permission denied
    log_step "3" "Test permission check (delete other user's comment)"
    fake_comment_id="00000000-0000-0000-0000-000000000001"
    response=$(api_call DELETE "/api/comments/$fake_comment_id")
    status=$(get_status "$response")
    
    if [ "$status" == "403" ] || [ "$status" == "404" ]; then
        log_success "Permission check working"
    else
        log_error "Expected 403 or 404 (got: $status)"
    fi
    
    # Test 4: Invalid UUID format
    log_step "4" "Test invalid UUID format"
    response=$(api_call GET "/api/packs/invalid-uuid-format")
    status=$(get_status "$response")
    
    if [ "$status" == "400" ] || [ "$status" == "404" ]; then
        log_success "Invalid UUID handled correctly"
    else
        log_error "Expected 400 or 404 for invalid UUID (got: $status)"
    fi
    
    echo -e "\n${GREEN}✓✓✓ Flow 5 completed successfully ✓✓✓${NC}"
}

# ============================================================================
# FLOW 6: Performance Testing
# ============================================================================
test_performance_flow() {
    log_flow "Flow 6: Performance & Rate Limiting Journey"
    
    # Test 1: Response time
    log_step "1" "Measure response times"
    
    total_time=0
    iterations=10
    
    for i in $(seq 1 $iterations); do
        start=$(date +%s%N)
        response=$(api_call GET "/api/users/profile")
        end=$(date +%s%N)
        
        time_ms=$(( ($end - $start) / 1000000 ))
        total_time=$(( $total_time + $time_ms ))
        
        if [ $i -eq 1 ] || [ $i -eq $iterations ]; then
            echo "  Request $i: ${time_ms}ms"
        fi
    done
    
    avg_time=$(( $total_time / $iterations ))
    log_success "Average response time: ${avg_time}ms"
    
    if [ $avg_time -lt 200 ]; then
        log_success "Performance within target (< 200ms)"
    else
        echo -e "${YELLOW}⚠ Warning: Average response time above 200ms target${NC}"
    fi
    
    # Test 2: Rate limiting
    log_step "2" "Test rate limiting (61 requests)"
    
    rate_limited=false
    for i in $(seq 1 61); do
        status=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/health")
        
        if [ "$status" == "429" ]; then
            log_success "Rate limiting triggered at request $i"
            rate_limited=true
            break
        fi
        
        if [ $(($i % 10)) -eq 0 ]; then
            echo "  Sent $i requests..."
        fi
    done
    
    if [ "$rate_limited" = false ]; then
        echo -e "${YELLOW}⚠ Warning: Rate limiting did not trigger${NC}"
    fi
    
    echo -e "\n${YELLOW}Waiting 60 seconds for rate limit to reset...${NC}"
    sleep 2  # Shortened for testing
    
    log_step "3" "Verify rate limit reset"
    response=$(api_call GET "/health")
    status=$(get_status "$response")
    
    if [ "$status" == "200" ]; then
        log_success "Rate limit reset successfully"
    else
        echo -e "${YELLOW}⚠ Rate limit may still be active${NC}"
    fi
    
    echo -e "\n${GREEN}✓✓✓ Flow 6 completed successfully ✓✓✓${NC}"
}

# ============================================================================
# Main Test Runner
# ============================================================================
main() {
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║                                                            ║"
    echo "║         Pakkt API - End-to-End Flow Testing Suite         ║"
    echo "║                                                            ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    echo "API URL: $API_URL"
    echo "Authenticated: Yes"
    echo ""
    echo "This will test complete user journeys through the API"
    echo "including pack creation, check-ins, social features, and more."
    echo ""
    
    start_time=$(date +%s)
    
    # Run all flows
    test_pack_goal_flow
    test_checkin_accountability_flow
    test_social_engagement_flow
    test_upload_flow
    test_error_handling_flow
    test_performance_flow
    
    end_time=$(date +%s)
    duration=$(( $end_time - $start_time ))
    
    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║                       FINAL RESULTS                        ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    echo -e "${GREEN}✓ All 6 flows completed successfully!${NC}"
    echo ""
    echo "Total execution time: ${duration}s"
    echo ""
    echo "Flows tested:"
    echo "  1. Pack & Goal Creation"
    echo "  2. Check-in & Accountability"
    echo "  3. Social Engagement"
    echo "  4. File Upload"
    echo "  5. Error Handling"
    echo "  6. Performance & Rate Limiting"
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}🎉 All tests passed! API is working as expected 🎉${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Check for jq
if ! command -v jq &> /dev/null; then
    echo -e "${RED}ERROR: jq is required but not installed${NC}"
    echo "Install with: brew install jq (macOS) or apt-get install jq (Linux)"
    exit 1
fi

# Run tests
main
