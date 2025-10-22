#!/bin/bash

# Pakkt API - Comprehensive Endpoint Testing Script
# This script tests all API endpoints with real HTTP requests

set -e

# Load environment variables from .dev.vars
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/load-env.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Load environment variables
if ! load_dev_vars; then
    exit 1
fi

# Configuration
API_URL="${API_URL:-http://localhost:8787}"
AUTH_TOKEN="${AUTH_TOKEN:-}"

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0

# Helper functions
log_test() {
    echo -e "\n${YELLOW}🧪 Testing: $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ PASS: $1${NC}"
    ((TESTS_PASSED++))
}

log_failure() {
    echo -e "${RED}❌ FAIL: $1${NC}"
    ((TESTS_FAILED++))
}

log_info() {
    echo -e "ℹ️  $1"
}

# Test health endpoint
test_health() {
    log_test "Health Check"
    
    response=$(curl -s -w "\n%{http_code}" "$API_URL/health")
    body=$(echo "$response" | head -n -1)
    status=$(echo "$response" | tail -n 1)
    
    if [ "$status" -eq 200 ]; then
        log_success "Health endpoint returned 200"
        echo "$body" | jq .
    else
        log_failure "Health endpoint returned $status"
    fi
}

# Test CORS headers
test_cors() {
    log_test "CORS Headers"
    
    response=$(curl -s -X OPTIONS -i "$API_URL/health" \
        -H "Origin: https://pakkt.app" \
        -H "Access-Control-Request-Method: GET")
    
    if echo "$response" | grep -q "Access-Control-Allow-Origin"; then
        log_success "CORS headers present"
    else
        log_failure "CORS headers missing"
    fi
}

# Test rate limiting
test_rate_limit() {
    log_test "Rate Limiting"
    
    log_info "Sending 65 requests to trigger rate limit..."
    
    for i in {1..65}; do
        status=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/health")
        if [ "$status" -eq 429 ]; then
            log_success "Rate limiting triggered at request $i"
            return
        fi
    done
    
    log_failure "Rate limiting did not trigger after 65 requests"
}

# Test authentication (requires token)
test_auth() {
    if [ -z "$AUTH_TOKEN" ]; then
        log_info "Skipping auth tests (no AUTH_TOKEN provided)"
        return
    fi
    
    log_test "Authentication - Valid Token"
    
    response=$(curl -s -w "\n%{http_code}" "$API_URL/api/me" \
        -H "Authorization: Bearer $AUTH_TOKEN")
    body=$(echo "$response" | head -n -1)
    status=$(echo "$response" | tail -n 1)
    
    if [ "$status" -eq 200 ]; then
        log_success "Valid token accepted"
        echo "$body" | jq .
    else
        log_failure "Valid token rejected (status: $status)"
    fi
}

test_auth_invalid() {
    log_test "Authentication - Invalid Token"
    
    status=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/api/me" \
        -H "Authorization: Bearer invalid_token_here")
    
    if [ "$status" -eq 401 ]; then
        log_success "Invalid token rejected"
    else
        log_failure "Invalid token not properly rejected (status: $status)"
    fi
}

test_auth_missing() {
    log_test "Authentication - Missing Token"
    
    status=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/api/me")
    
    if [ "$status" -eq 401 ]; then
        log_success "Missing token rejected"
    else
        log_failure "Missing token not properly rejected (status: $status)"
    fi
}

# User endpoints
test_user_profile() {
    if [ -z "$AUTH_TOKEN" ]; then
        log_info "Skipping user profile tests (no AUTH_TOKEN)"
        return
    fi
    
    log_test "GET /api/users/profile"
    
    response=$(curl -s -w "\n%{http_code}" "$API_URL/api/users/profile" \
        -H "Authorization: Bearer $AUTH_TOKEN")
    body=$(echo "$response" | head -n -1)
    status=$(echo "$response" | tail -n 1)
    
    if [ "$status" -eq 200 ]; then
        log_success "Get profile successful"
        echo "$body" | jq .
    else
        log_failure "Get profile failed (status: $status)"
    fi
}

test_update_profile() {
    if [ -z "$AUTH_TOKEN" ]; then
        log_info "Skipping update profile tests (no AUTH_TOKEN)"
        return
    fi
    
    log_test "PATCH /api/users/profile"
    
    response=$(curl -s -w "\n%{http_code}" -X PATCH "$API_URL/api/users/profile" \
        -H "Authorization: Bearer $AUTH_TOKEN" \
        -H "Content-Type: application/json" \
        -d '{"username": "testuser_'$(date +%s)'", "bio": "Testing API"}')
    body=$(echo "$response" | head -n -1)
    status=$(echo "$response" | tail -n 1)
    
    if [ "$status" -eq 200 ]; then
        log_success "Update profile successful"
        echo "$body" | jq .
    else
        log_failure "Update profile failed (status: $status)"
        echo "$body"
    fi
}

# Pack endpoints
test_create_pack() {
    if [ -z "$AUTH_TOKEN" ]; then
        log_info "Skipping pack creation tests (no AUTH_TOKEN)"
        return
    fi
    
    log_test "POST /api/packs"
    
    response=$(curl -s -w "\n%{http_code}" -X POST "$API_URL/api/packs" \
        -H "Authorization: Bearer $AUTH_TOKEN" \
        -H "Content-Type: application/json" \
        -d '{
            "name": "Test Pack '$(date +%s)'",
            "description": "Created by test script",
            "visibility": "private",
            "max_members": 10
        }')
    body=$(echo "$response" | head -n -1)
    status=$(echo "$response" | tail -n 1)
    
    if [ "$status" -eq 201 ]; then
        log_success "Create pack successful"
        PACK_ID=$(echo "$body" | jq -r '.data.id')
        echo "$body" | jq .
        echo "$PACK_ID" > /tmp/pakkt_test_pack_id
    else
        log_failure "Create pack failed (status: $status)"
        echo "$body"
    fi
}

test_get_pack() {
    if [ -z "$AUTH_TOKEN" ] || [ ! -f /tmp/pakkt_test_pack_id ]; then
        log_info "Skipping get pack test (no token or pack)"
        return
    fi
    
    PACK_ID=$(cat /tmp/pakkt_test_pack_id)
    log_test "GET /api/packs/:id"
    
    response=$(curl -s -w "\n%{http_code}" "$API_URL/api/packs/$PACK_ID" \
        -H "Authorization: Bearer $AUTH_TOKEN")
    body=$(echo "$response" | head -n -1)
    status=$(echo "$response" | tail -n 1)
    
    if [ "$status" -eq 200 ]; then
        log_success "Get pack successful"
        echo "$body" | jq .
    else
        log_failure "Get pack failed (status: $status)"
    fi
}

# Goal endpoints
test_create_goal() {
    if [ -z "$AUTH_TOKEN" ] || [ ! -f /tmp/pakkt_test_pack_id ]; then
        log_info "Skipping goal creation (no token or pack)"
        return
    fi
    
    PACK_ID=$(cat /tmp/pakkt_test_pack_id)
    log_test "POST /api/packs/:packId/goals"
    
    response=$(curl -s -w "\n%{http_code}" -X POST "$API_URL/api/packs/$PACK_ID/goals" \
        -H "Authorization: Bearer $AUTH_TOKEN" \
        -H "Content-Type: application/json" \
        -d '{
            "name": "Test Goal",
            "description": "Daily exercise",
            "recurrence": "daily",
            "checkin_time": "09:00",
            "requires_proof": true
        }')
    body=$(echo "$response" | head -n -1)
    status=$(echo "$response" | tail -n 1)
    
    if [ "$status" -eq 201 ]; then
        log_success "Create goal successful"
        GOAL_ID=$(echo "$body" | jq -r '.data.id')
        echo "$body" | jq .
        echo "$GOAL_ID" > /tmp/pakkt_test_goal_id
    else
        log_failure "Create goal failed (status: $status)"
        echo "$body"
    fi
}

# Upload endpoints
test_presigned_url() {
    if [ -z "$AUTH_TOKEN" ]; then
        log_info "Skipping presigned URL test (no AUTH_TOKEN)"
        return
    fi
    
    log_test "POST /api/uploads/presigned-url"
    
    response=$(curl -s -w "\n%{http_code}" -X POST "$API_URL/api/uploads/presigned-url" \
        -H "Authorization: Bearer $AUTH_TOKEN" \
        -H "Content-Type: application/json" \
        -d '{
            "file_type": "image/jpeg",
            "purpose": "checkin"
        }')
    body=$(echo "$response" | head -n -1)
    status=$(echo "$response" | tail -n 1)
    
    if [ "$status" -eq 200 ]; then
        log_success "Presigned URL generation successful"
        echo "$body" | jq .
    else
        log_failure "Presigned URL generation failed (status: $status)"
        echo "$body"
    fi
}

# Error handling tests
test_error_404() {
    log_test "Error Handling - 404 Not Found"
    
    response=$(curl -s -w "\n%{http_code}" "$API_URL/api/nonexistent")
    body=$(echo "$response" | head -n -1)
    status=$(echo "$response" | tail -n 1)
    
    if [ "$status" -eq 404 ]; then
        log_success "404 error handled correctly"
    else
        log_failure "404 not handled correctly (status: $status)"
    fi
}

test_error_validation() {
    if [ -z "$AUTH_TOKEN" ]; then
        log_info "Skipping validation error test (no AUTH_TOKEN)"
        return
    fi
    
    log_test "Error Handling - Validation Error"
    
    response=$(curl -s -w "\n%{http_code}" -X PATCH "$API_URL/api/users/profile" \
        -H "Authorization: Bearer $AUTH_TOKEN" \
        -H "Content-Type: application/json" \
        -d '{"username": ""}')
    body=$(echo "$response" | head -n -1)
    status=$(echo "$response" | tail -n 1)
    
    if [ "$status" -eq 400 ]; then
        log_success "Validation error handled correctly"
        echo "$body" | jq .
    else
        log_failure "Validation error not handled correctly (status: $status)"
    fi
}

# Run all tests
main() {
    echo "================================================"
    echo "  Pakkt API - Endpoint Testing Suite"
    echo "================================================"
    echo "API URL: $API_URL"
    if [ -n "$AUTH_TOKEN" ]; then
        echo "Auth: Provided"
    else
        echo "Auth: Not provided (auth tests will be skipped)"
        echo "  To run auth tests, set AUTH_TOKEN environment variable"
    fi
    echo "================================================"
    
    # Infrastructure tests
    test_health
    test_cors
    test_rate_limit
    
    # Authentication tests
    test_auth_missing
    test_auth_invalid
    test_auth
    
    # User tests
    test_user_profile
    test_update_profile
    
    # Pack tests
    test_create_pack
    test_get_pack
    
    # Goal tests
    test_create_goal
    
    # Upload tests
    test_presigned_url
    
    # Error handling tests
    test_error_404
    test_error_validation
    
    # Summary
    echo ""
    echo "================================================"
    echo "  Test Summary"
    echo "================================================"
    echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
    echo -e "${RED}Failed: $TESTS_FAILED${NC}"
    echo "================================================"
    
    # Cleanup
    rm -f /tmp/pakkt_test_pack_id /tmp/pakkt_test_goal_id
    
    if [ $TESTS_FAILED -gt 0 ]; then
        exit 1
    fi
}

# Run main
main
