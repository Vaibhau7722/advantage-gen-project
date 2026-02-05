#!/bin/bash

# AdVantage Gen API Testing Script
# This script tests all API endpoints to verify the backend is working

echo "🧪 AdVantage Gen API Test Suite"
echo "================================"
echo ""

BASE_URL="http://localhost:5000"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
PASS=0
FAIL=0

# Helper function to test endpoint
test_endpoint() {
    local name=$1
    local method=$2
    local endpoint=$3
    local data=$4
    
    echo "Testing: $name"
    
    if [ "$method" == "GET" ]; then
        response=$(curl -s -w "\n%{http_code}" "$BASE_URL$endpoint")
    elif [ "$method" == "POST" ]; then
        response=$(curl -s -w "\n%{http_code}" -X POST \
            -H "Content-Type: application/json" \
            -d "$data" \
            "$BASE_URL$endpoint")
    fi
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$http_code" == "200" ]; then
        echo -e "${GREEN}✓ PASS${NC} - HTTP $http_code"
        ((PASS++))
    else
        echo -e "${RED}✗ FAIL${NC} - HTTP $http_code"
        echo "Response: $body"
        ((FAIL++))
    fi
    echo ""
}

# Test 1: Health Check
echo "📊 Test 1: Health Check"
test_endpoint "Health endpoint" "GET" "/api/health"

# Test 2: Image Generation
echo "🎨 Test 2: Simple Image Generation"
test_endpoint "Generate image" "POST" "/api/generate-image" \
    '{"prompt":"A beautiful sunset over mountains"}'

# Test 3: Get Campaigns (should return empty array initially)
echo "📚 Test 3: Get Campaign History"
test_endpoint "Get campaigns" "GET" "/api/campaigns"

# Test 4: Generate Full Campaign (requires multipart/form-data, so using curl directly)
echo "🚀 Test 4: Full Campaign Generation"
echo "Testing: Generate complete campaign"
campaign_response=$(curl -s -w "\n%{http_code}" -X POST \
    -F "prompt=Modern coffee shop with natural lighting" \
    -F "tone=Professional" \
    -F "ctaText=Visit Now" \
    -F "aspectRatio=square" \
    -F "userId=test-user" \
    "$BASE_URL/api/generate-campaign")

campaign_http_code=$(echo "$campaign_response" | tail -n1)
campaign_body=$(echo "$campaign_response" | sed '$d')

if [ "$campaign_http_code" == "200" ]; then
    echo -e "${GREEN}✓ PASS${NC} - HTTP $campaign_http_code"
    ((PASS++))
    
    # Extract campaign ID for next tests
    CAMPAIGN_ID=$(echo "$campaign_body" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
    echo "Campaign ID: $CAMPAIGN_ID"
else
    echo -e "${RED}✗ FAIL${NC} - HTTP $campaign_http_code"
    echo "Response: $campaign_body"
    ((FAIL++))
fi
echo ""

# Test 5: Get Single Campaign
if [ ! -z "$CAMPAIGN_ID" ]; then
    echo "📄 Test 5: Get Single Campaign"
    test_endpoint "Get campaign by ID" "GET" "/api/campaigns/$CAMPAIGN_ID"
    
    # Test 6: Update Campaign
    echo "✏️ Test 6: Update Campaign"
    test_endpoint "Update campaign" "POST" "/api/campaigns/$CAMPAIGN_ID" \
        '{"caption":"Updated caption text","hashtags":["#updated","#test"]}'
    
    # Test 7: Remix Campaign
    echo "🎭 Test 7: Remix Campaign"
    test_endpoint "Remix campaign" "POST" "/api/campaigns/$CAMPAIGN_ID/remix" \
        '{"variation":"with warmer colors and evening lighting"}'
else
    echo -e "${YELLOW}⚠ SKIP${NC} - Tests 5-7 skipped (no campaign ID)"
    echo ""
fi

# Summary
echo "================================"
echo "📊 Test Results Summary"
echo "================================"
echo -e "Passed: ${GREEN}$PASS${NC}"
echo -e "Failed: ${RED}$FAIL${NC}"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some tests failed${NC}"
    exit 1
fi
