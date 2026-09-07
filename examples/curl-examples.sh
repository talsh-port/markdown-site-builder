#!/bin/bash

# Markdown Site Builder API - cURL Examples
#
# This file contains cURL commands to interact with the Markdown Site Builder API
#
# Usage: bash curl-examples.sh
# Or run individual commands manually

set -e  # Exit on error

API_BASE="http://localhost:3000/api"

echo "=========================================="
echo "Markdown Site Builder API - cURL Examples"
echo "=========================================="
echo ""

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper function to print section headers
print_section() {
    echo -e "${BLUE}=========================================="
    echo "$1"
    echo "==========================================${NC}"
    echo ""
}

# Helper function to print curl command
print_command() {
    echo -e "${YELLOW}$ $1${NC}"
}

# 1. CREATE A PAGE
print_section "1. CREATE A NEW PAGE"

print_command "curl -X POST $API_BASE/pages \\"
echo "  -H \"Content-Type: application/json\" \\"
echo "  -d '{\"title\": \"Welcome\", \"content\": \"# Welcome\\n\\nThis is my first page!\"}'"

PAGE_RESPONSE=$(curl -s -X POST "$API_BASE/pages" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Welcome to Markdown",
    "content": "# Welcome!\n\nThis is my first page created with cURL.\n\n## Features\n- Easy markdown support\n- Clean API\n- Static HTML generation"
  }')

echo ""
echo -e "${GREEN}Response:${NC}"
echo "$PAGE_RESPONSE" | jq '.'
echo ""

# Extract the page ID from the response
PAGE_ID=$(echo "$PAGE_RESPONSE" | jq -r '.id')
echo -e "${GREEN}Page ID: $PAGE_ID${NC}"
echo ""

# 2. GET ALL PAGES
print_section "2. GET ALL PAGES"

print_command "curl $API_BASE/pages"
echo ""

curl -s "$API_BASE/pages" | jq '.'
echo ""

# 3. GET A SPECIFIC PAGE
print_section "3. GET A SPECIFIC PAGE"

print_command "curl $API_BASE/pages/$PAGE_ID"
echo ""

SINGLE_PAGE=$(curl -s "$API_BASE/pages/$PAGE_ID")
echo -e "${GREEN}Response:${NC}"
echo "$SINGLE_PAGE" | jq '.'
echo ""

# 4. UPDATE A PAGE
print_section "4. UPDATE A PAGE"

print_command "curl -X PUT $API_BASE/pages/$PAGE_ID \\"
echo "  -H \"Content-Type: application/json\" \\"
echo "  -d '{\"content\": \"# Updated Content\\n\\nThis page has been updated!\"}'"

UPDATED_PAGE=$(curl -s -X PUT "$API_BASE/pages/$PAGE_ID" \
  -H "Content-Type: application/json" \
  -d '{
    "content": "# Updated Welcome Page!\n\nThis page has been updated using cURL.\n\n## Updated Features\n- Dynamic updates\n- Real-time changes\n- Easy to use API\n\nEverything is working great!"
  }')

echo ""
echo -e "${GREEN}Response:${NC}"
echo "$UPDATED_PAGE" | jq '.'
echo ""

# 5. DELETE A PAGE
print_section "5. DELETE A PAGE"

print_command "curl -X DELETE $API_BASE/pages/$PAGE_ID"
echo ""

DELETE_RESPONSE=$(curl -s -X DELETE "$API_BASE/pages/$PAGE_ID")
echo -e "${GREEN}Response:${NC}"
echo "$DELETE_RESPONSE" | jq '.'
echo ""

# 6. ADDITIONAL EXAMPLES
print_section "ADDITIONAL EXAMPLES"

echo -e "${YELLOW}Example: Create a Blog Post${NC}"
print_command "curl -X POST $API_BASE/pages \\"
cat << 'EOF'
  -H "Content-Type: application/json" \
  -d '{
    "title": "My First Blog Post",
    "content": "# My First Blog Post\n\nDate: September 7, 2026\n\n## Introduction\n\nWelcome to my blog!\n\n## Content\n\nHere is the main content of my post.\n\n## Conclusion\n\nThanks for reading!"
  }'
EOF
echo ""

echo -e "${YELLOW}Example: Create API Documentation Page${NC}"
print_command "curl -X POST $API_BASE/pages \\"
cat << 'EOF'
  -H "Content-Type: application/json" \
  -d '{
    "title": "API Reference",
    "content": "# API Reference\n\n## Endpoints\n\n### GET /api/pages\nRetrieve all pages.\n\n### POST /api/pages\nCreate a new page.\n\n### PUT /api/pages/:id\nUpdate a page.\n\n### DELETE /api/pages/:id\nDelete a page."
  }'
EOF
echo ""

# 7. BATCH OPERATIONS
print_section "BATCH OPERATIONS"

echo -e "${YELLOW}Creating 3 pages...${NC}"
echo ""

for i in {1..3}; do
    print_command "Creating page $i..."

    BATCH_PAGE=$(curl -s -X POST "$API_BASE/pages" \
      -H "Content-Type: application/json" \
      -d "{
        \"title\": \"Batch Page $i\",
        \"content\": \"# Page $i\n\nThis is page $i created in batch.\n\nContent for page $i goes here.\"
      }")

    BATCH_ID=$(echo "$BATCH_PAGE" | jq -r '.id')
    echo -e "${GREEN}✓ Created page with ID: $BATCH_ID${NC}"
    echo ""
done

# 8. ERROR HANDLING
print_section "ERROR HANDLING EXAMPLES"

echo -e "${YELLOW}Example: Missing Required Fields${NC}"
print_command "curl -X POST $API_BASE/pages \\"
echo '  -H "Content-Type: application/json" \\'
echo '  -d '"'"'{\"title\": \"No Content\"}'"'"''
echo ""

curl -s -X POST "$API_BASE/pages" \
  -H "Content-Type: application/json" \
  -d '{"title": "No Content"}' | jq '.'
echo ""

echo -e "${YELLOW}Example: Page Not Found${NC}"
print_command "curl $API_BASE/pages/invalid-id"
echo ""

curl -s "$API_BASE/pages/invalid-id" | jq '.'
echo ""

# 9. USEFUL CURL OPTIONS
print_section "USEFUL cURL OPTIONS"

echo -e "${YELLOW}Save output to file:${NC}"
echo "curl $API_BASE/pages > pages.json"
echo ""

echo -e "${YELLOW}Pretty print JSON:${NC}"
echo "curl $API_BASE/pages | jq '.'"
echo ""

echo -e "${YELLOW}Show response headers:${NC}"
echo "curl -i $API_BASE/pages"
echo ""

echo -e "${YELLOW}Show only HTTP status code:${NC}"
echo "curl -o /dev/null -s -w '%{http_code}' $API_BASE/pages"
echo ""

echo -e "${YELLOW}Verbose output:${NC}"
echo "curl -v $API_BASE/pages"
echo ""

echo -e "${YELLOW}Follow redirects:${NC}"
echo "curl -L $API_BASE/pages"
echo ""

echo -e "${YELLOW}Add custom header:${NC}"
echo "curl -H 'X-Custom-Header: value' $API_BASE/pages"
echo ""

echo -e "${YELLOW}Use form data instead of JSON:${NC}"
echo "curl -X POST $API_BASE/pages -F title='My Page' -F content='Content'"
echo ""

# Summary
print_section "SUMMARY"

echo -e "${GREEN}✓ Examples completed!${NC}"
echo ""
echo "Key points:"
echo "- API base URL: $API_BASE"
echo "- All requests must use Content-Type: application/json (except file uploads)"
echo "- Use jq for pretty-printing JSON: curl ... | jq '.'"
echo "- Check HTTP status codes for error handling"
echo "- Page IDs are timestamps in Unix milliseconds"
echo ""

# Cleanup: Remove all test pages
print_section "CLEANUP"

echo -e "${YELLOW}Removing test pages...${NC}"
echo ""

# Get all pages and delete them
ALL_PAGES=$(curl -s "$API_BASE/pages")
PAGE_COUNT=$(echo "$ALL_PAGES" | jq 'length')

echo "Found $PAGE_COUNT page(s) to clean up"
echo ""

echo "$ALL_PAGES" | jq -r '.[] | .id' | while read id; do
    print_command "Deleting page $id..."
    curl -s -X DELETE "$API_BASE/pages/$id" | jq '.'
    echo ""
done

echo -e "${GREEN}✓ Cleanup completed!${NC}"
echo ""
echo "All test pages have been removed."
