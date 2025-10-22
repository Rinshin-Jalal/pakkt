#!/bin/bash

# Pakkt API Complete Testing Script
# Usage: ./test-complete-api.sh [base_url] [auth_token]

set -e

# Load environment variables from .dev.vars
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/load-env.sh"

# Load environment variables
if ! load_dev_vars; then
    exit 1
fi

# Configuration
BASE_URL="${1:-http://localhost:8787}"
AUTH_TOKEN="${2:-$AUTH_TOKEN}"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables to store IDs
PACK_ID=""
GOAL_ID=""
CHECKIN_ID=""
FINE_ID=""
JAIL_ID=""

# Helper functions
print_header() {
    echo -e "\n${BLUE}================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================================${NC}\n"
}

print_test() {
    echo -e "${YELLOW}▶ Testing:${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓ Success:${NC} $1"
}

print_error() {
    echo -e "${RED}✗ Error:${NC} $1"
}

make_request() {
    local method=$1
    local endpoint=$2
    local data=$3
    local description=$4
    
    print_test "$description"
    
    if [ -z "$AUTH_TOKEN" ] && [ "$endpoint" != "/health" ]; then
        print_error "No auth token provided. Use: $0 <base_url> <auth_token>"
        return 1
    fi
    
    local cmd="curl -s -X $method \"$BASE_URL$endpoint\""
    
    if [ ! -z "$AUTH_TOKEN" ]; then
        cmd="$cmd -H \"Authorization: Bearer $AUTH_TOKEN\""
    fi
    
    cmd="$cmd -H \"Content-Type: application/json\""
    
    if [ ! -z "$data" ]; then
        cmd="$cmd -d '$data'"
    fi
    
    echo "Request: $method $endpoint"
    local response=$(eval $cmd)
    echo "$response" | jq '.' 2>/dev/null || echo "$response"
    
    # Extract IDs from response
    if echo "$response" | jq -e '.data.id' > /dev/null 2>&1; then
        local id=$(echo "$response" | jq -r '.data.id')
        print_success "Created resource with ID: $id"
        echo "$id"
    fi
    
    echo ""
}

# ================================================
# START TESTS
# ================================================

print_header "PAKKT API COMPLETE TEST SUITE"

# ================================================
# 1. HEALTH & AUTH
# ================================================
print_header "1. Health & Auth Tests"

make_request "GET" "/health" "" "Health Check"

if [ ! -z "$AUTH_TOKEN" ]; then
    make_request "GET" "/api/me" "" "Get Authenticated User"
    make_request "GET" "/api/feed" "" "Get Feed (with auth)"
fi

# ================================================
# 2. USERS
# ================================================
print_header "2. Users Tests"

make_request "GET" "/api/users/profile" "" "Get Profile"

make_request "PATCH" "/api/users/profile" '{
  "username": "TestUser_'$(date +%s)'",
  "bio": "Testing the Pakkt API! 🚀"
}' "Update Profile"

make_request "POST" "/api/users/push-token" '{
  "token": "ExponentPushToken[test_'$(date +%s)']",
  "device_type": "ios"
}' "Register Push Token"

# ================================================
# 3. PACKS
# ================================================
print_header "3. Packs Tests"

PACK_ID=$(make_request "POST" "/api/packs" '{
  "name": "Test Pack '$(date +%s)'",
  "description": "Automated test pack",
  "visibility": "private"
}' "Create Pack" | tail -n 1)

if [ ! -z "$PACK_ID" ]; then
    print_success "Pack created: $PACK_ID"
    
    make_request "GET" "/api/packs" "" "Get User Packs"
    
    make_request "GET" "/api/packs/$PACK_ID" "" "Get Pack Details"
    
    make_request "PATCH" "/api/packs/$PACK_ID" '{
      "description": "Updated automated test pack"
    }' "Update Pack"
    
    make_request "GET" "/api/packs/$PACK_ID/stats" "" "Get Pack Stats"
else
    print_error "Failed to create pack, skipping pack tests"
fi

# ================================================
# 4. GOALS
# ================================================
print_header "4. Goals Tests"

if [ ! -z "$PACK_ID" ]; then
    GOAL_ID=$(make_request "POST" "/api/packs/$PACK_ID/goals" '{
      "title": "Test Goal '$(date +%s)'",
      "description": "Automated test goal",
      "recurrence_pattern": "daily",
      "check_in_time": "08:00",
      "requires_proof": false,
      "fine_amount_cents": 500
    }' "Create Goal" | tail -n 1)
    
    if [ ! -z "$GOAL_ID" ]; then
        print_success "Goal created: $GOAL_ID"
        
        make_request "GET" "/api/packs/$PACK_ID/goals" "" "List Pack Goals"
        
        make_request "GET" "/api/goals/my-active" "" "Get My Active Goals"
        
        make_request "GET" "/api/goals/$GOAL_ID" "" "Get Goal Details"
        
        make_request "GET" "/api/goals/$GOAL_ID/stats" "" "Get Goal Stats"
        
        make_request "PATCH" "/api/goals/$GOAL_ID" '{
          "description": "Updated test goal"
        }' "Update Goal"
        
        make_request "POST" "/api/goals/$GOAL_ID/toggle" "" "Toggle Goal Status"
        
        # Toggle back to active
        make_request "POST" "/api/goals/$GOAL_ID/toggle" "" "Toggle Goal Status (back to active)"
    else
        print_error "Failed to create goal, skipping goal tests"
    fi
else
    print_error "No pack available, skipping goal tests"
fi

# ================================================
# 5. CHECK-INS
# ================================================
print_header "5. Check-ins Tests"

if [ ! -z "$GOAL_ID" ]; then
    CHECKIN_ID=$(make_request "POST" "/api/checkins" '{
      "goal_id": "'$GOAL_ID'",
      "note": "Automated test check-in! 💪"
    }' "Create Check-in" | tail -n 1)
    
    if [ ! -z "$CHECKIN_ID" ]; then
        print_success "Check-in created: $CHECKIN_ID"
        
        make_request "GET" "/api/checkins/feed" "" "Get Feed"
        
        make_request "GET" "/api/packs/$PACK_ID/checkins" "" "Get Pack Check-ins"
        
        make_request "GET" "/api/checkins/$CHECKIN_ID" "" "Get Check-in Details"
        
        make_request "GET" "/api/checkins/stats" "" "Get My Check-in Stats"
    else
        print_error "Failed to create check-in, skipping check-in tests"
    fi
else
    print_error "No goal available, skipping check-in tests"
fi

# ================================================
# 6. FINES
# ================================================
print_header "6. Fines Tests"

# Note: In real scenario, fines would be created for missed check-ins
# For testing, we'll skip fine creation as it requires specific user scenarios

echo "Fines tests require specific user scenarios (missed check-ins)"
echo "Testing fine retrieval endpoints only:"

make_request "GET" "/api/fines/my" "" "Get My Fines"

if [ ! -z "$PACK_ID" ]; then
    make_request "GET" "/api/packs/$PACK_ID/fines" "" "List Pack Fines"
fi

# ================================================
# 7. JAIL
# ================================================
print_header "7. Jail Tests"

# Note: Jail sessions are typically triggered by fines
# For testing purposes, we can create a test session

if [ ! -z "$GOAL_ID" ]; then
    JAIL_ID=$(make_request "POST" "/api/jail/start" '{
      "goal_id": "'$GOAL_ID'",
      "duration_minutes": 5,
      "blocked_apps": ["com.instagram.ios", "com.twitter.ios"],
      "reason": "Test jail session"
    }' "Start Jail Session" | tail -n 1)
    
    if [ ! -z "$JAIL_ID" ]; then
        print_success "Jail session started: $JAIL_ID"
        
        make_request "GET" "/api/jail/active" "" "Get Active Jail Sessions"
        
        make_request "GET" "/api/jail/$JAIL_ID" "" "Get Jail Session Status"
        
        make_request "POST" "/api/jail/$JAIL_ID/heartbeat" '{
          "timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'"
        }' "Send Heartbeat"
        
        # Wait a bit
        sleep 2
        
        make_request "POST" "/api/jail/$JAIL_ID/heartbeat" '{
          "timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'"
        }' "Send Another Heartbeat"
    else
        print_error "Failed to start jail session"
    fi
else
    print_error "No goal available, skipping jail tests"
fi

# ================================================
# 8. SOCIAL (Reactions & Comments)
# ================================================
print_header "8. Social Tests"

if [ ! -z "$CHECKIN_ID" ]; then
    make_request "POST" "/api/reactions" '{
      "target_type": "checkin",
      "target_id": "'$CHECKIN_ID'",
      "emoji": "🔥"
    }' "Add Reaction (Fire)"
    
    # Update reaction
    make_request "POST" "/api/reactions" '{
      "target_type": "checkin",
      "target_id": "'$CHECKIN_ID'",
      "emoji": "💪"
    }' "Update Reaction (Muscle)"
    
    make_request "GET" "/api/checkins/$CHECKIN_ID/reactions" "" "Get Check-in Reactions"
    
    COMMENT_RESPONSE=$(make_request "POST" "/api/comments" '{
      "checkin_id": "'$CHECKIN_ID'",
      "content": "Great job! Automated test comment 🎉"
    }' "Add Comment")
    
    make_request "GET" "/api/checkins/$CHECKIN_ID/comments" "" "Get Check-in Comments"
    
    make_request "GET" "/api/feed-events" "" "Get Feed Events"
else
    print_error "No check-in available, skipping social tests"
fi

# ================================================
# 9. UPLOADS
# ================================================
print_header "9. Uploads Tests"

if [ ! -z "$PACK_ID" ]; then
    make_request "POST" "/api/uploads/presigned-url" '{
      "file_type": "image/jpeg",
      "purpose": "checkin",
      "pack_id": "'$PACK_ID'"
    }' "Generate Presigned URL"
    
    make_request "GET" "/api/uploads/history?limit=10" "" "Get Upload History"
    
    make_request "GET" "/api/uploads/stats" "" "Get Upload Stats"
else
    print_error "No pack available, skipping upload tests"
fi

# ================================================
# CLEANUP (Optional)
# ================================================
print_header "Cleanup (Optional)"

echo "Created resources:"
echo "- Pack ID: $PACK_ID"
echo "- Goal ID: $GOAL_ID"
echo "- Check-in ID: $CHECKIN_ID"
echo "- Jail ID: $JAIL_ID"
echo ""
echo "To clean up manually, use DELETE endpoints"

# Uncomment to auto-cleanup
# if [ ! -z "$CHECKIN_ID" ]; then
#     make_request "DELETE" "/api/checkins/$CHECKIN_ID" "" "Delete Check-in"
# fi
# if [ ! -z "$GOAL_ID" ]; then
#     make_request "DELETE" "/api/goals/$GOAL_ID" "" "Delete Goal"
# fi
# if [ ! -z "$PACK_ID" ]; then
#     make_request "DELETE" "/api/packs/$PACK_ID" "" "Dissolve Pack"
# fi

# ================================================
# SUMMARY
# ================================================
print_header "TEST SUMMARY"

echo -e "${GREEN}All tests completed!${NC}"
echo ""
echo "Review the output above for any errors."
echo "Check that responses match expected schemas."
echo ""
echo "For detailed testing, import the Postman collection:"
echo "Collection ID: 18337693-b8b5-4c25-8233-22bd6f435584"
echo ""
echo "See POSTMAN_COMPLETE_GUIDE.md for full documentation."
