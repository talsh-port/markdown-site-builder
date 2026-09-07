# Markdown Site Builder - API Documentation

## Overview

The Markdown Site Builder API provides RESTful endpoints for managing markdown pages. All responses are in JSON format, and requests should include `Content-Type: application/json` header for POST/PUT requests.

### Base URL

```
http://localhost:3000/api
```

### API Version

- **Current Version**: 1.0.0
- **Last Updated**: 2026-09-07

---

## Table of Contents

1. [Authentication](#authentication)
2. [Error Handling](#error-handling)
3. [Endpoints](#endpoints)
   - [Pages](#pages)
4. [Request/Response Examples](#requestresponse-examples)
5. [Status Codes](#status-codes)
6. [Rate Limiting](#rate-limiting)
7. [Pagination](#pagination)
8. [Best Practices](#best-practices)

---

## Authentication

Currently, the API does not require authentication. All endpoints are publicly accessible.

**Note**: For production deployments, consider implementing API key authentication or JWT tokens.

---

## Error Handling

All error responses follow a consistent format:

```json
{
  "error": "Error message describing what went wrong"
}
```

### Common Error Scenarios

| Scenario | Status Code | Response |
|----------|-------------|----------|
| Missing required fields | 400 | `{ "error": "Title and content are required" }` |
| Page not found | 404 | `{ "error": "Page not found" }` |
| Server error | 500 | `{ "error": "Internal server error message" }` |

---

## Endpoints

### Pages

#### 1. Create a New Page

Create a new markdown page and generate its static HTML output.

**Endpoint**: `POST /api/pages`

**Headers**:
```
Content-Type: application/json
```

**Request Body**:
```json
{
  "title": "string (required)",
  "content": "string (required, markdown format)"
}
```

**Parameters**:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| title | string | Yes | Page title (will be URL-slugified) |
| content | string | Yes | Markdown content for the page |

**Response** (201 Created):
```json
{
  "id": "1725858123456",
  "title": "My First Page",
  "slug": "my-first-page",
  "content": "# Hello World\n\nThis is my first page!",
  "html": "<h1>Hello World</h1>\n<p>This is my first page!</p>",
  "createdAt": "2026-09-07T10:35:23.456Z",
  "updatedAt": "2026-09-07T10:35:23.456Z"
}
```

**Curl Example**:
```bash
curl -X POST http://localhost:3000/api/pages \
  -H "Content-Type: application/json" \
  -d '{
    "title": "My First Page",
    "content": "# Hello World\n\nThis is my first page!"
  }'
```

---

#### 2. Get All Pages

Retrieve a list of all pages in the system.

**Endpoint**: `GET /api/pages`

**Query Parameters**: None

**Response** (200 OK):
```json
[
  {
    "id": "1725858123456",
    "title": "My First Page",
    "slug": "my-first-page",
    "content": "# Hello World\n\nThis is my first page!",
    "html": "<h1>Hello World</h1>\n<p>This is my first page!</p>",
    "createdAt": "2026-09-07T10:35:23.456Z",
    "updatedAt": "2026-09-07T10:35:23.456Z"
  },
  {
    "id": "1725858234567",
    "title": "Second Page",
    "slug": "second-page",
    "content": "# Welcome\n\nThis is the second page.",
    "html": "<h1>Welcome</h1>\n<p>This is the second page.</p>",
    "createdAt": "2026-09-07T10:40:34.567Z",
    "updatedAt": "2026-09-07T10:40:34.567Z"
  }
]
```

**Empty Response** (200 OK):
```json
[]
```

**Curl Example**:
```bash
curl http://localhost:3000/api/pages
```

---

#### 3. Get a Single Page

Retrieve details of a specific page by its ID.

**Endpoint**: `GET /api/pages/:id`

**URL Parameters**:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| id | string | Yes | Unique page identifier |

**Response** (200 OK):
```json
{
  "id": "1725858123456",
  "title": "My First Page",
  "slug": "my-first-page",
  "content": "# Hello World\n\nThis is my first page!",
  "html": "<h1>Hello World</h1>\n<p>This is my first page!</p>",
  "createdAt": "2026-09-07T10:35:23.456Z",
  "updatedAt": "2026-09-07T10:35:23.456Z"
}
```

**Error Response** (404 Not Found):
```json
{
  "error": "Page not found"
}
```

**Curl Example**:
```bash
curl http://localhost:3000/api/pages/1725858123456
```

---

#### 4. Update a Page

Update an existing page's title and/or content. The HTML is automatically regenerated.

**Endpoint**: `PUT /api/pages/:id`

**Headers**:
```
Content-Type: application/json
```

**URL Parameters**:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| id | string | Yes | Unique page identifier |

**Request Body**:
```json
{
  "title": "string (optional)",
  "content": "string (optional, markdown format)"
}
```

**Parameters**:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| title | string | No | New page title |
| content | string | No | New markdown content |

**Notes**:
- At least one field (title or content) must be provided
- Only provided fields will be updated
- The `updatedAt` timestamp is automatically set to current time
- HTML is automatically regenerated if content is provided
- The page slug remains the same even if title is updated

**Response** (200 OK):
```json
{
  "id": "1725858123456",
  "title": "Updated Title",
  "slug": "my-first-page",
  "content": "# Updated Content\n\nThis is updated!",
  "html": "<h1>Updated Content</h1>\n<p>This is updated!</p>",
  "createdAt": "2026-09-07T10:35:23.456Z",
  "updatedAt": "2026-09-07T10:45:00.000Z"
}
```

**Error Responses**:
- 404 Not Found: `{ "error": "Page not found" }`
- 500 Server Error: `{ "error": "Error message" }`

**Curl Example** (Update content only):
```bash
curl -X PUT http://localhost:3000/api/pages/1725858123456 \
  -H "Content-Type: application/json" \
  -d '{
    "content": "# Updated Content\n\nThis is updated!"
  }'
```

**Curl Example** (Update title only):
```bash
curl -X PUT http://localhost:3000/api/pages/1725858123456 \
  -H "Content-Type: application/json" \
  -d '{
    "title": "New Title"
  }'
```

---

#### 5. Delete a Page

Permanently delete a page and its output HTML file.

**Endpoint**: `DELETE /api/pages/:id`

**URL Parameters**:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| id | string | Yes | Unique page identifier |

**Response** (200 OK):
```json
{
  "success": true
}
```

**Error Response** (404 Not Found):
```json
{
  "error": "Page not found"
}
```

**Curl Example**:
```bash
curl -X DELETE http://localhost:3000/api/pages/1725858123456
```

---

## Request/Response Examples

### Complete Workflow Example

#### Step 1: Create a Page
```bash
curl -X POST http://localhost:3000/api/pages \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Getting Started with Markdown",
    "content": "# Getting Started\n\n## What is Markdown?\n\nMarkdown is a lightweight markup language...\n\n## Features\n- Easy to learn\n- Widely supported\n- Perfect for documentation"
  }'
```

**Response**:
```json
{
  "id": "1725858500000",
  "title": "Getting Started with Markdown",
  "slug": "getting-started-with-markdown",
  "content": "# Getting Started\n\n## What is Markdown?\n\nMarkdown is a lightweight markup language...\n\n## Features\n- Easy to learn\n- Widely supported\n- Perfect for documentation",
  "html": "<h1>Getting Started</h1>\n<h2>What is Markdown?</h2>\n<p>Markdown is a lightweight markup language...</p>\n<h2>Features</h2>\n<ul>\n<li>Easy to learn</li>\n<li>Widely supported</li>\n<li>Perfect for documentation</li>\n</ul>",
  "createdAt": "2026-09-07T10:58:20.000Z",
  "updatedAt": "2026-09-07T10:58:20.000Z"
}
```

#### Step 2: Retrieve All Pages
```bash
curl http://localhost:3000/api/pages
```

#### Step 3: Update the Page
```bash
curl -X PUT http://localhost:3000/api/pages/1725858500000 \
  -H "Content-Type: application/json" \
  -d '{
    "content": "# Getting Started with Markdown\n\n## What is Markdown?\n\nMarkdown is a lightweight markup language that is widely used.\n\n## Features\n- Easy to learn\n- Widely supported\n- Perfect for documentation\n- Great for blogs"
  }'
```

#### Step 4: Delete the Page
```bash
curl -X DELETE http://localhost:3000/api/pages/1725858500000
```

---

## Status Codes

The API uses standard HTTP status codes to indicate the result of requests:

| Code | Name | Description |
|------|------|-------------|
| 200 | OK | Request successful; data returned in response body |
| 201 | Created | Resource created successfully |
| 400 | Bad Request | Invalid request format or missing required parameters |
| 404 | Not Found | Requested resource does not exist |
| 500 | Internal Server Error | Server encountered an unexpected condition |

---

## Rate Limiting

Currently, there is no rate limiting implemented. However, for production deployments, consider implementing:

- Request rate limiting (e.g., 100 requests per minute per IP)
- Maximum payload size limits
- Connection timeouts

---

## Pagination

The current implementation does not support pagination. All pages are returned in a single response.

**Future Enhancement**: Implement cursor-based or offset-based pagination with the following parameters:
- `limit`: Number of items per page (default: 20, max: 100)
- `offset`: Number of items to skip (default: 0)
- `page`: Page number (1-indexed, alternative to offset)

Example format:
```
GET /api/pages?limit=10&offset=0
```

---

## Markdown Support

The API supports full CommonMark markdown syntax. This includes:

### Basic Formatting
```markdown
**bold text**
*italic text*
~~strikethrough~~
`inline code`
```

### Headings
```markdown
# Heading 1
## Heading 2
### Heading 3
#### Heading 4
##### Heading 5
###### Heading 6
```

### Lists
```markdown
- Unordered list item 1
- Unordered list item 2
  - Nested item

1. Ordered list item 1
2. Ordered list item 2
   1. Nested ordered item
```

### Links and Images
```markdown
[Link text](https://example.com)
![Alt text](https://example.com/image.jpg)
```

### Code Blocks
```markdown
\`\`\`javascript
function hello() {
  console.log("Hello, World!");
}
\`\`\`
```

### Blockquotes
```markdown
> This is a blockquote
> It can span multiple lines
>> Nested blockquotes are also supported
```

### Tables
```markdown
| Header 1 | Header 2 |
|----------|----------|
| Cell 1   | Cell 2   |
| Cell 3   | Cell 4   |
```

---

## Data Model

### Page Object

Every page in the system has the following structure:

```json
{
  "id": "string",
  "title": "string",
  "slug": "string",
  "content": "string",
  "html": "string",
  "createdAt": "string (ISO 8601)",
  "updatedAt": "string (ISO 8601)"
}
```

**Field Descriptions**:

| Field | Type | Description |
|-------|------|-------------|
| id | string | Unique identifier (Unix timestamp-based) |
| title | string | Human-readable page title |
| slug | string | URL-safe version of title (lowercased, hyphens instead of spaces) |
| content | string | Original markdown content |
| html | string | Generated HTML from markdown |
| createdAt | string | ISO 8601 timestamp of page creation |
| updatedAt | string | ISO 8601 timestamp of last update |

---

## Best Practices

### 1. Error Handling
Always check the HTTP status code and handle errors appropriately:

```javascript
fetch('/api/pages', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ title, content })
})
.then(response => {
  if (!response.ok) {
    return response.json().then(err => {
      throw new Error(err.error);
    });
  }
  return response.json();
})
.catch(error => console.error('Error:', error));
```

### 2. Input Validation
Validate input before sending to the API:

```javascript
function validatePageInput(title, content) {
  if (!title || title.trim().length === 0) {
    throw new Error('Title is required');
  }
  if (!content || content.trim().length === 0) {
    throw new Error('Content is required');
  }
  if (title.length > 200) {
    throw new Error('Title must be less than 200 characters');
  }
  return true;
}
```

### 3. Content Safety
- Sanitize user input on the client side for display
- The API automatically escapes markdown content to prevent XSS
- Consider server-side validation and sanitization for production

### 4. Idempotency
- DELETE operations: Deleting an already-deleted page returns 404
- PUT operations: Updating with identical data is safe and repeatable
- POST operations: Creating the same page twice will create two separate pages

### 5. Caching
- Store page lists in local state to reduce API calls
- Implement a cache with reasonable TTL for frequently accessed pages
- Clear cache after creating, updating, or deleting pages

### 6. Batch Operations
For bulk operations, make individual API calls. For future optimization, consider implementing batch endpoints:

```
POST /api/pages/batch
DELETE /api/pages/batch
PUT /api/pages/batch
```

---

## Troubleshooting

### Common Issues

**Issue**: "Port 3000 is already in use"
- **Solution**: Change the PORT environment variable or kill the process using port 3000

**Issue**: "Page created but not appearing in list"
- **Solution**: Wait a moment (data is in-memory), or refresh the page list

**Issue**: "Cannot read property of undefined"
- **Solution**: Check that the page ID is correct and the page exists before making requests

**Issue**: "HTML output directory is not created"
- **Solution**: The directory is created automatically; check file permissions if it fails

---

## Security Considerations

### Current Limitations (for Development)

⚠️ **Note**: The current implementation is suitable for development and small-scale use. For production, consider:

1. **Authentication & Authorization**
   - Implement API key or JWT authentication
   - Add role-based access control (RBAC)
   - Implement user-specific page isolation

2. **Input Validation**
   - Add field length limits
   - Validate markdown for potentially malicious content
   - Implement XSS protection

3. **Rate Limiting**
   - Add request throttling
   - Implement DDoS protection
   - Add per-user or per-IP limits

4. **Data Persistence**
   - Replace in-memory storage with a database
   - Implement data backup and recovery
   - Add transaction support

5. **HTTPS**
   - Use HTTPS in production
   - Implement HSTS headers

6. **Logging & Monitoring**
   - Add comprehensive logging
   - Monitor API usage and performance
   - Set up alerts for anomalies

---

## Development

### Environment Variables

```bash
PORT=3000              # Server port (default: 3000)
NODE_ENV=development   # Environment (development or production)
```

### Testing the API

Use any of these tools to test the API:

1. **curl** (command line)
2. **Postman** (GUI application)
3. **Insomnia** (GUI application)
4. **Thunder Client** (VS Code extension)
5. **REST Client** (VS Code extension)

### Running Tests

```bash
npm test
```

---

## Support & Contributing

For issues, questions, or contributions, please:

1. Check the [main README.md](./README.md) for general project information
2. Open an issue on GitHub
3. Submit a pull request with your contributions

---

## Changelog

### Version 1.0.0 (2026-09-07)
- Initial API implementation
- Full CRUD operations for pages
- Markdown to HTML conversion
- Static HTML file generation

---

## License

MIT - See LICENSE file for details
