# Getting Started with the Markdown Site Builder API

This guide will help you get up and running with the Markdown Site Builder API.

## Prerequisites

- Node.js 14 or higher
- npm or yarn
- A tool to make HTTP requests (curl, Postman, Insomnia, etc.)

## Installation & Setup

### 1. Install Dependencies

```bash
npm install
```

### 2. Start the Development Server

```bash
npm run dev
```

You should see output like:
```
📝 Markdown Site Builder running at http://localhost:3000
📂 Output directory: /path/to/output
```

### 3. Verify the API is Running

Test the health endpoint:

```bash
curl http://localhost:3000/health
```

Expected response:
```json
{ "status": "ok" }
```

## Your First Page

### Step 1: Create a Page

```bash
curl -X POST http://localhost:3000/api/pages \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Welcome to My Site",
    "content": "# Welcome!\n\nThis is my first page using the Markdown Site Builder.\n\n## Features\n- Easy to use\n- Markdown support\n- Generate static HTML"
  }'
```

**Response:**
```json
{
  "id": "1725858123456",
  "title": "Welcome to My Site",
  "slug": "welcome-to-my-site",
  "content": "# Welcome!\n\nThis is my first page using the Markdown Site Builder.\n\n## Features\n- Easy to use\n- Markdown support\n- Generate static HTML",
  "html": "<h1>Welcome!</h1>\n<p>This is my first page using the Markdown Site Builder.</p>\n<h2>Features</h2>\n<ul>\n<li>Easy to use</li>\n<li>Markdown support</li>\n<li>Generate static HTML</li>\n</ul>",
  "createdAt": "2026-09-07T10:35:23.456Z",
  "updatedAt": "2026-09-07T10:35:23.456Z"
}
```

Save the `id` from the response - you'll need it for the next steps!

### Step 2: View All Pages

```bash
curl http://localhost:3000/api/pages
```

This will return an array of all pages you've created.

### Step 3: Get a Specific Page

Replace `YOUR_PAGE_ID` with the ID from Step 1:

```bash
curl http://localhost:3000/api/pages/YOUR_PAGE_ID
```

### Step 4: Update a Page

```bash
curl -X PUT http://localhost:3000/api/pages/YOUR_PAGE_ID \
  -H "Content-Type: application/json" \
  -d '{
    "content": "# Welcome!\n\nUpdated content!\n\n## New Features\n- Updated easily\n- Still supports Markdown\n- Still generates static HTML"
  }'
```

### Step 5: Delete a Page

```bash
curl -X DELETE http://localhost:3000/api/pages/YOUR_PAGE_ID
```

## Using the Web UI

While the API is running, you can also use the web interface:

1. Open http://localhost:3000 in your browser
2. Enter a page title and markdown content
3. Click "Create Page"
4. See your page appear in the "Your Pages" section
5. Edit or delete pages as needed

## Common Use Cases

### Blog Post

```bash
curl -X POST http://localhost:3000/api/pages \
  -H "Content-Type: application/json" \
  -d '{
    "title": "My First Blog Post",
    "content": "# My First Blog Post\n\nDate: September 7, 2026\n\n## Introduction\n\nWelcome to my first blog post!\n\n## Main Content\n\nHere is my content about the topic.\n\n## Conclusion\n\nThanks for reading!"
  }'
```

### Documentation Page

```bash
curl -X POST http://localhost:3000/api/pages \
  -H "Content-Type: application/json" \
  -d '{
    "title": "API Documentation",
    "content": "# API Documentation\n\n## Getting Started\n\nTo get started with our API, follow these steps:\n\n1. Install dependencies\n2. Start the server\n3. Create your first page\n\n## Endpoints\n\n### GET /api/pages\n\nRetrieve all pages.\n\n### POST /api/pages\n\nCreate a new page."
  }'
```

### About Page

```bash
curl -X POST http://localhost:3000/api/pages \
  -H "Content-Type: application/json" \
  -d '{
    "title": "About Us",
    "content": "# About Us\n\n## Our Mission\n\nWe believe in making content creation simple and accessible.\n\n## Our Team\n\n- Developer\n- Designer\n- Marketer\n\n## Contact\n\nReach out to us at contact@example.com"
  }'
```

## Tips & Best Practices

### 1. Use Meaningful Titles
Titles are automatically converted to URL slugs, so use clear, descriptive titles:
- ✅ "Getting Started with React"
- ❌ "Page 1"

### 2. Format Your Markdown
Use proper markdown formatting for better readability:
```markdown
# Heading 1
## Heading 2
### Heading 3

**Bold text**
*Italic text*

- Bullet points
- Work great

1. Numbered
2. Lists too
```

### 3. Keep Content Organized
- Use headings to organize sections
- Use lists for quick information
- Use code blocks for examples

### 4. Update Regularly
Use the PUT endpoint to keep your content fresh:
```bash
curl -X PUT http://localhost:3000/api/pages/YOUR_PAGE_ID \
  -H "Content-Type: application/json" \
  -d '{"content": "Updated content..."}'
```

## Troubleshooting

### Q: The server won't start
**A:** Check if port 3000 is already in use. Either:
- Kill the process using port 3000
- Set a different port: `PORT=3001 npm run dev`

### Q: Pages aren't persisting
**A:** The current implementation stores data in memory, so pages are lost when the server restarts. This is perfect for development but you'll want to use a database in production.

### Q: I'm getting CORS errors
**A:** Make sure you're using the correct base URL. By default, use `http://localhost:3000/api`

### Q: The API returns "Page not found"
**A:** Double-check the page ID is correct. List all pages with `curl http://localhost:3000/api/pages`

## Next Steps

- Read the [full API documentation](../API.md)
- Check out [example implementations](../examples)
- Explore the [OpenAPI specification](../openapi.json)
- Deploy to production (see [deployment guide](./DEPLOYMENT.md))

## Support

Having issues? Check:
1. The main [README.md](../README.md)
2. The [API documentation](../API.md)
3. Open a GitHub issue

Happy building! 🚀
