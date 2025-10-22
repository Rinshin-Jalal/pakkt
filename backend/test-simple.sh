#!/bin/bash

set -e

echo "Step 1: Starting test"

# Load environment variables
source ./scripts/load-env.sh
echo "Step 2: Environment loaded"

# Configuration
API_BASE="http://localhost:8787"
TOKEN="eyJhbGciOiJIUzI1NiIsImtpZCI6IjJlb0s0V0RVNzR6aFY5YkYiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL251cXp6dGhsdHB1ZGFjcGpkeWZ5LnN1cGFiYXNlLmNvL2F1dGgvdjEiLCJzdWIiOiJiMDk1MGI0OC0xNjQxLTQ0ODMtYmIyZi0xMTMyZDEyMzJkYzAiLCJhdWQiOiJhdXRoZW50aWNhdGVkIiwiZXhwIjoxNzYxMTIzNTAyLCJpYXQiOjE3NjExMTk5MDIsImVtYWlsIjoiaGV5QHJpbnNoLmluIiwicGhvbmUiOiIiLCJhcHBfbWV0YWRhdGEiOnsicHJvdmlkZXIiOiJlbWFpbCIsInByb3ZpZGVycyI6WyJlbWFpbCJdfSwidXNlcl9tZXRhZGF0YSI6eyJlbWFpbF92ZXJpZmllZCI6dHJ1ZX0sInJvbGUiOiJhdXRoZW50aWNhdGVkIiwiYWFsIjoiYWFsMSIsImFtciI6W3sibWV0aG9kIjoicGFzc3dvcmQiLCJ0aW1lc3RhbXAiOjE3NjExMTk5MDJ9XSwic2Vzc2lvbl9pZCI6IjA2ZTZjMTM4LTU1NjctNGZjYy1hMDFlLWNjNTYzNmEzNTIwMSIsImlzX2Fub255bW91cyI6ZmFsc2V9.Ok0VlD6lJUr-aP9cGnOAhChp4Buu7iJ_fPdCowCwrk0"

echo "Step 3: Variables set"

# Check server
echo "Step 4: Checking server..."
RESPONSE=$(curl -s -w "\n%{http_code}" "$API_BASE/health")
echo "Step 5: Response received: $RESPONSE"
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
echo "Step 6: HTTP_CODE: $HTTP_CODE"
BODY=$(echo "$RESPONSE" | sed '$d')
echo "Step 7: BODY: $BODY"

if [ "$HTTP_CODE" = "200" ]; then
    echo "Step 8: Server check passed"
else
    echo "Step 8: Server check failed"
    exit 1
fi

echo "Step 9: Test completed successfully"