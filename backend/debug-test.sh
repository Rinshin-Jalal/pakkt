#!/bin/bash

set -e

# Load environment variables
source ./scripts/load-env.sh

# Configuration
API_BASE="http://localhost:8787"
TOKEN="eyJhbGciOiJIUzI1NiIsImtpZCI6IjJlb0s0V0RVNzR6aFY5YkYiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL251cXp6dGhsdHB1ZGFjcGpkeWZ5LnN1cGFiYXNlLmNvL2F1dGgvdjEiLCJzdWIiOiJiMDk1MGI0OC0xNjQxLTQ0ODMtYmIyZi0xMTMyZDEyMzJkYzAiLCJhdWQiOiJhdXRoZW50aWNhdGVkIiwiZXhwIjoxNzYxMTIzNTAyLCJpYXQiOjE3NjExMTk5MDIsImVtYWlsIjoiaGV5QHJpbnNoLmluIiwicGhvbmUiOiIiLCJhcHBfbWV0YWRhdGEiOnsicHJvdmlkZXIiOiJlbWFpbCIsInByb3ZpZGVycyI6WyJlbWFpbCJdfSwidXNlcl9tZXRhZGF0YSI6eyJlbWFpbF92ZXJpZmllZCI6dHJ1ZX0sInJvbGUiOiJhdXRoZW50aWNhdGVkIiwiYWFsIjoiYWFsMSIsImFtciI6W3sibWV0aG9kIjoicGFzc3dvcmQiLCJ0aW1lc3RhbXAiOjE3NjExMTk5MDJ9XSwic2Vzc2lvbl9pZCI6IjA2ZTZjMTM4LTU1NjctNGZjYy1hMDFlLWNjNTYzNmEzNTIwMSIsImlzX2Fub255bW91cyI6ZmFsc2V9.Ok0VlD6lJUr-aP9cGnOAhChp4Buu7iJ_fPdCowCwrk0"

echo "Step 1: Environment loaded"

# Check server
echo "Step 2: Checking server..."
RESPONSE=$(curl -s -w "\n%{http_code}" "$API_BASE/health")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

echo "Step 3: Server response - HTTP: $HTTP_CODE"
if [ "$HTTP_CODE" = "200" ]; then
    echo "Step 4: Server check passed"
else
    echo "Step 4: Server check failed"
    exit 1
fi

# Check auth
echo "Step 5: Checking auth..."
RESPONSE=$(curl -s -w "\n%{http_code}" -H "Authorization: Bearer $TOKEN" "$API_BASE/api/me")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)

echo "Step 6: Auth response - HTTP: $HTTP_CODE"
if [ "$HTTP_CODE" = "200" ]; then
    USER_ID=$(echo "$RESPONSE" | sed '$d' | jq -r '.data.userId')
    echo "Step 7: Auth check passed - User: $USER_ID"
else
    echo "Step 7: Auth check failed"
    exit 1
fi

echo "Step 8: All checks passed!"