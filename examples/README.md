# Markdown Site Builder API - Examples

This directory contains example implementations of the Markdown Site Builder API in different languages and frameworks.

## Quick Links

- [JavaScript (Fetch API)](./javascript-fetch.js) - Browser-compatible API client
- [Python (Requests)](./python-requests.py) - Python HTTP client with class-based API
- [Node.js Client](./nodejs-client.js) - Reusable Node.js library
- [cURL Commands](./curl-examples.sh) - Command-line examples with shell script

## Getting Started

### Prerequisites

Before running any examples, make sure:
1. The Markdown Site Builder server is running on `http://localhost:3000`
2. You have the necessary tools installed (curl, Node.js, Python, etc.)

### Running the Server

```bash
npm install
npm run dev
```

Server should be running at `http://localhost:3000`

## Example Implementations

### 1. JavaScript (Fetch API)

**File**: `javascript-fetch.js`

Basic example using the Fetch API - works in browsers and Node.js.

**Features**:
- Simple functions for each API operation
- Error handling
- Complete workflow example

**Usage in Browser**:
```html
<script src="javascript-fetch.js"></script>
<script>
  createPage('My Title', '# Hello World')
    .then(page => console.log('Created:', page))
    .catch(error => console.error('Error:', error));
</script>
```

**Usage in Node.js**:
```javascript
const { 
  createPage, 
  getAllPages, 
  updatePage, 
  deletePage 
} = require('./javascript-fetch.js');

// Use the functions
```

### 2. Python (Requests)

**File**: `python-requests.py`

Full-featured Python client library with class-based API.

**Features**:
- Object-oriented design
- Type hints
- Comprehensive error handling
- Session management
- Batch operations

**Installation**:
```bash
pip install requests
```

**Usage**:
```python
from python_requests import MarkdownSiteBuilderAPI

client = MarkdownSiteBuilderAPI()

# Create a page
page = client.create_page('My Title', '# Hello World')

# Get all pages
pages = client.get_all_pages()

# Update a page
updated = client.update_page(page['id'], content='# Updated')

# Delete a page
client.delete_page(page['id'])
```

**Run Examples**:
```bash
python python-requests.py
```

### 3. Node.js Client

**File**: `nodejs-client.js`

Reusable Node.js HTTP client library using native modules.

**Features**:
- Uses only Node.js built-in modules (no external dependencies)
- Promise-based API
- Request timeout handling
- Batch operations
- Search functionality

**Installation**:
```bash
# No external dependencies needed!
```

**Usage**:
```javascript
const { MarkdownSiteBuilderClient } = require('./nodejs-client');

const client = new MarkdownSiteBuilderClient();

// Create a page
const page = await client.createPage('Title', 'Content');

// Get all pages
const pages = await client.getAllPages();

// Update a page
const updated = await client.updatePage(page.id, { content: 'Updated' });

// Delete a page
await client.deletePage(page.id);

// Search pages
const results = await client.searchPages('query');
```

**Run Examples**:
```bash
node nodejs-client.js
```

### 4. cURL Examples

**File**: `curl-examples.sh`

Shell script with comprehensive cURL examples.

**Features**:
- Color-coded output
- Step-by-step examples
- Error handling examples
- Batch operations
- Automatic cleanup

**Usage**:
```bash
# Make the script executable
chmod +x curl-examples.sh

# Run it
./curl-examples.sh
```

**Manual Examples**:

Create a page:
```bash
curl -X POST http://localhost:3000/api/pages \
  -H "Content-Type: application/json" \
  -d '{"title": "My Page", "content": "# Hello"}'
```

Get all pages:
```bash
curl http://localhost:3000/api/pages | jq '.'
```

Get a specific page:
```bash
curl http://localhost:3000/api/pages/{page-id}
```

Update a page:
```bash
curl -X PUT http://localhost:3000/api/pages/{page-id} \
  -H "Content-Type: application/json" \
  -d '{"content": "# Updated"}'
```

Delete a page:
```bash
curl -X DELETE http://localhost:3000/api/pages/{page-id}
```

## Common Patterns

### Error Handling

**JavaScript**:
```javascript
try {
  const page = await createPage('Title', 'Content');
} catch (error) {
  console.error('Error:', error.message);
}
```

**Python**:
```python
try:
  page = client.create_page('Title', 'Content')
except Exception as e:
  print(f'Error: {e}')
```

**Node.js**:
```javascript
try {
  const page = await client.createPage('Title', 'Content');
} catch (error) {
  console.error('Error:', error.message);
}
```

### Batch Operations

**Python**:
```python
pages_data = [
  {'title': 'Page 1', 'content': 'Content 1'},
  {'title': 'Page 2', 'content': 'Content 2'},
  {'title': 'Page 3', 'content': 'Content 3'},
]
created = batch_create_pages(pages_data)
```

**Node.js**:
```javascript
const pagesData = [
  { title: 'Page 1', content: 'Content 1' },
  { title: 'Page 2', content: 'Content 2' },
];
const created = await client.createPages(pagesData);
```

### Searching Pages

**Python**:
```python
results = client.search_pages('query')
for page in results:
  print(f'{page["title"]}: {page["slug"]}')
```

**Node.js**:
```javascript
const results = await client.searchPages('query');
results.forEach(page => console.log(page.title));
```

## Tips & Tricks

### Using jq for JSON Pretty-Printing

With cURL, pipe to `jq` for better output:
```bash
curl http://localhost:3000/api/pages | jq '.'
```

### Saving Output to Variables

**Bash**:
```bash
RESPONSE=$(curl -s http://localhost:3000/api/pages)
PAGE_ID=$(echo $RESPONSE | jq -r '.[0].id')
```

### Timing API Requests

**Bash**:
```bash
time curl http://localhost:3000/api/pages > /dev/null
```

**Python**:
```python
import time
start = time.time()
pages = client.get_all_pages()
print(f'Time: {time.time() - start:.2f}s')
```

### Testing with Different Content Types

**Markdown with Code Blocks**:
```bash
curl -X POST http://localhost:3000/api/pages \
  -H "Content-Type: application/json" \
  -d '{"title": "Code Example", "content": "```javascript\nconsole.log(\"hello\");\n```"}'
```

**Markdown with Tables**:
```bash
curl -X POST http://localhost:3000/api/pages \
  -H "Content-Type: application/json" \
  -d '{"title": "Table Example", "content": "| Col1 | Col2 |\n|------|------|\n| A    | B    |"}'
```

## Troubleshooting

### "Connection refused" Error
**Problem**: Server not running
**Solution**: Make sure the server is running with `npm run dev`

### "Module not found" (Python)
**Problem**: Missing dependencies
**Solution**: Install with `pip install requests`

### "Command not found: jq"
**Problem**: jq not installed
**Solution**: Install jq (macOS: `brew install jq`, Linux: `apt-get install jq`)

### Timeout Errors
**Problem**: Requests taking too long
**Solution**: Check if server is overloaded or network is slow

## Performance Benchmarks

These are approximate times on a local machine:

| Operation | Time |
|-----------|------|
| Create page | ~10ms |
| Read all pages (10 pages) | ~5ms |
| Read single page | ~3ms |
| Update page | ~10ms |
| Delete page | ~5ms |

## Next Steps

1. Try each example in your preferred language
2. Modify the examples for your use case
3. Integrate into your own application
4. Check out the [API Documentation](../API.md) for more details
5. See the [Getting Started Guide](../docs/GETTING_STARTED.md) for a full walkthrough

## Contributing

Have a new example or improvement? 
1. Add your implementation to this directory
2. Update this README
3. Submit a pull request

## Support

For questions or issues:
1. Check the [API Documentation](../API.md)
2. Review the [Getting Started Guide](../docs/GETTING_STARTED.md)
3. Open a GitHub issue

## License

MIT - All examples are provided as-is for educational purposes.
