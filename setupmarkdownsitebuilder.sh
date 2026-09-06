#!/bin/bash
set -e

echo "🚀 Setting up Markdown Site Builder..."

# Create directories
mkdir -p public output

# Create .gitignore
cat > .gitignore << 'EOF'
node_modules/
output/
.env
.env.local
.DS_Store
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
dist/
build/
.idea/
.vscode/
*.swp
*.swo
*~
.coverage
EOF

# Create .env.example
cat > .env.example << 'EOF'
PORT=3000
NODE_ENV=development
EOF

# Create package.json
cat > package.json << 'EOF'
{
  "name": "markdown-site-builder",
  "version": "1.0.0",
  "description": "A simple Node.js static site generator - convert markdown files to a beautiful static website",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js",
    "test": "jest",
    "lint": "eslint ."
  },
  "keywords": [
    "markdown",
    "static-site",
    "generator",
    "blog",
    "documentation"
  ],
  "author": "Your Name",
  "license": "MIT",
  "dependencies": {
    "express": "^4.18.2",
    "marked": "^9.0.0",
    "fs-extra": "^11.1.1",
    "dotenv": "^16.0.3",
    "slugify": "^1.6.5"
  },
  "devDependencies": {
    "nodemon": "^3.0.1",
    "jest": "^29.5.0",
    "eslint": "^8.40.0"
  }
}
EOF

# Create server.js
cat > server.js << 'EOF'
const express = require('express');
const path = require('path');
const fs = require('fs-extra');
const marked = require('marked');
const slugify = require('slugify');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'public')));

// Store for pages (in-memory for demo)
let pages = [];

// Ensure output directory exists
const outputDir = path.join(__dirname, 'output');
fs.ensureDirSync(outputDir);

/**
 * Convert markdown to HTML
 */
function markdownToHtml(markdown) {
  return marked.parse(markdown);
}

/**
 * Create a new page
 */
app.post('/api/pages', (req, res) => {
  try {
    const { title, content } = req.body;

    if (!title || !content) {
      return res.status(400).json({ error: 'Title and content are required' });
    }

    const slug = slugify(title, { lower: true, strict: true });
    const html = markdownToHtml(content);

    const page = {
      id: Date.now().toString(),
      title,
      slug,
      content,
      html,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };

    pages.push(page);

    // Save to output directory
    const outputFile = path.join(outputDir, `${slug}.html`);
    const htmlContent = generatePageHtml(page);
    fs.writeFileSync(outputFile, htmlContent);

    res.status(201).json(page);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/**
 * Get all pages
 */
app.get('/api/pages', (req, res) => {
  try {
    res.json(pages);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/**
 * Get a single page
 */
app.get('/api/pages/:id', (req, res) => {
  try {
    const page = pages.find(p => p.id === req.params.id);
    if (!page) {
      return res.status(404).json({ error: 'Page not found' });
    }
    res.json(page);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/**
 * Update a page
 */
app.put('/api/pages/:id', (req, res) => {
  try {
    const pageIndex = pages.findIndex(p => p.id === req.params.id);
    if (pageIndex === -1) {
      return res.status(404).json({ error: 'Page not found' });
    }

    const { title, content } = req.body;
    const page = pages[pageIndex];

    if (title) page.title = title;
    if (content) {
      page.content = content;
      page.html = markdownToHtml(content);
    }
    page.updatedAt = new Date().toISOString();

    // Update output file
    const slug = page.slug;
    const outputFile = path.join(outputDir, `${slug}.html`);
    const htmlContent = generatePageHtml(page);
    fs.writeFileSync(outputFile, htmlContent);

    res.json(page);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/**
 * Delete a page
 */
app.delete('/api/pages/:id', (req, res) => {
  try {
    const pageIndex = pages.findIndex(p => p.id === req.params.id);
    if (pageIndex === -1) {
      return res.status(404).json({ error: 'Page not found' });
    }

    const page = pages[pageIndex];
    pages.splice(pageIndex, 1);

    // Delete output file
    const slug = page.slug;
    const outputFile = path.join(outputDir, `${slug}.html`);
    fs.removeSync(outputFile);

    res.json({ success: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/**
 * Generate complete HTML page
 */
function generatePageHtml(page) {
  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${page.title} | Markdown Site Builder</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', sans-serif; line-height: 1.6; color: #333; }
    .container { max-width: 800px; margin: 0 auto; padding: 2rem; }
    h1, h2, h3 { margin-top: 1.5rem; margin-bottom: 0.5rem; }
    p { margin-bottom: 1rem; }
    code { background: #f4f4f4; padding: 0.2rem 0.4rem; border-radius: 3px; font-family: 'Courier New', monospace; }
    pre { background: #f4f4f4; padding: 1rem; border-radius: 5px; overflow-x: auto; margin-bottom: 1rem; }
    a { color: #0066cc; text-decoration: none; }
    a:hover { text-decoration: underline; }
    .meta { color: #666; font-size: 0.9rem; margin-bottom: 2rem; }
  </style>
</head>
<body>
  <div class="container">
    <h1>${page.title}</h1>
    <div class="meta">
      <p>Created: ${new Date(page.createdAt).toLocaleDateString()}</p>
    </div>
    <div class="content">
      ${page.html}
    </div>
  </div>
</body>
</html>`;
}

/**
 * Health check
 */
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// Start server
app.listen(PORT, () => {
  console.log(`📝 Markdown Site Builder running at http://localhost:${PORT}`);
  console.log(`📂 Output directory: ${outputDir}`);
});
EOF

# Create public/index.html
cat > public/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Markdown Site Builder</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      padding: 2rem;
    }

    .container {
      max-width: 1200px;
      margin: 0 auto;
    }

    header {
      text-align: center;
      color: white;
      margin-bottom: 3rem;
    }

    header h1 {
      font-size: 2.5rem;
      margin-bottom: 0.5rem;
    }

    header p {
      font-size: 1.1rem;
      opacity: 0.9;
    }

    .content {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 2rem;
      margin-bottom: 2rem;
    }

    .card {
      background: white;
      border-radius: 8px;
      padding: 2rem;
      box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
    }

    .card h2 {
      color: #333;
      margin-bottom: 1.5rem;
      font-size: 1.5rem;
    }

    textarea {
      width: 100%;
      min-height: 300px;
      padding: 1rem;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-family: 'Courier New', monospace;
      font-size: 0.9rem;
      resize: vertical;
    }

    input[type="text"] {
      width: 100%;
      padding: 0.75rem;
      margin-bottom: 1rem;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-size: 1rem;
    }

    button {
      width: 100%;
      padding: 0.75rem;
      background: #667eea;
      color: white;
      border: none;
      border-radius: 4px;
      font-size: 1rem;
      cursor: pointer;
      transition: background 0.3s;
    }

    button:hover {
      background: #764ba2;
    }

    button:disabled {
      background: #ccc;
      cursor: not-allowed;
    }

    .pages-list {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
      gap: 1.5rem;
    }

    .page-card {
      background: white;
      border-radius: 8px;
      padding: 1.5rem;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      transition: transform 0.2s;
    }

    .page-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2);
    }

    .page-card h3 {
      color: #333;
      margin-bottom: 0.5rem;
    }

    .page-card p {
      color: #666;
      font-size: 0.9rem;
      margin-bottom: 1rem;
    }

    .page-card .actions {
      display: flex;
      gap: 0.5rem;
    }

    .page-card button {
      flex: 1;
      padding: 0.5rem;
      font-size: 0.9rem;
    }

    .message {
      padding: 1rem;
      margin-bottom: 1rem;
      border-radius: 4px;
      display: none;
    }

    .message.success {
      background: #d4edda;
      color: #155724;
      border: 1px solid #c3e6cb;
      display: block;
    }

    .message.error {
      background: #f8d7da;
      color: #721c24;
      border: 1px solid #f5c6cb;
      display: block;
    }

    .loading {
      text-align: center;
      color: white;
      font-size: 1.1rem;
    }

    @media (max-width: 768px) {
      .content {
        grid-template-columns: 1fr;
      }

      header h1 {
        font-size: 2rem;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <header>
      <h1>📝 Markdown Site Builder</h1>
      <p>Create beautiful static sites from markdown</p>
    </header>

    <div class="content">
      <div class="card">
        <h2>Create New Page</h2>
        <div id="message" class="message"></div>
        <input
          type="text"
          id="title"
          placeholder="Page Title"
          required
        />
        <textarea
          id="content"
          placeholder="Enter your markdown content here...

## Getting Started

Use **markdown** to format your content!

- Lists work great
- With multiple items
- And more features"
        ></textarea>
        <button onclick="createPage()">Create Page</button>
      </div>

      <div class="card">
        <h2>Your Pages</h2>
        <div id="pagesList" class="pages-list"></div>
        <div id="loadingPages" class="loading">Loading pages...</div>
      </div>
    </div>
  </div>

  <script>
    // Load and display all pages
    async function loadPages() {
      try {
        const response = await fetch('/api/pages');
        const pages = await response.json();

        const pagesList = document.getElementById('pagesList');
        const loadingPages = document.getElementById('loadingPages');

        if (pages.length === 0) {
          pagesList.innerHTML = '<p style="grid-column: 1/-1; color: #999;">No pages yet. Create one to get started!</p>';
          loadingPages.style.display = 'none';
          return;
        }

        pagesList.innerHTML = pages
          .map(page => `
            <div class="page-card">
              <h3>${page.title}</h3>
              <p>${page.content.substring(0, 100)}...</p>
              <p style="font-size: 0.8rem; color: #999;">
                ${new Date(page.createdAt).toLocaleDateString()}
              </p>
              <div class="actions">
                <button onclick="editPage('${page.id}')">Edit</button>
                <button onclick="deletePage('${page.id}')">Delete</button>
              </div>
            </div>
          `)
          .join('');

        loadingPages.style.display = 'none';
      } catch (error) {
        console.error('Error loading pages:', error);
        document.getElementById('loadingPages').innerHTML =
          '<p style="color: #999;">Error loading pages</p>';
      }
    }

    // Create new page
    async function createPage() {
      const title = document.getElementById('title').value;
      const content = document.getElementById('content').value;
      const messageEl = document.getElementById('message');

      if (!title || !content) {
        messageEl.textContent = 'Please fill in both title and content';
        messageEl.className = 'message error';
        return;
      }

      try {
        const response = await fetch('/api/pages', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ title, content })
        });

        if (!response.ok) throw new Error('Failed to create page');

        messageEl.textContent = '✓ Page created successfully!';
        messageEl.className = 'message success';

        document.getElementById('title').value = '';
        document.getElementById('content').value = '';

        setTimeout(() => {
          messageEl.className = 'message';
          loadPages();
        }, 2000);
      } catch (error) {
        messageEl.textContent = `Error: ${error.message}`;
        messageEl.className = 'message error';
      }
    }

    // Edit page
    async function editPage(id) {
      alert('Edit feature coming soon! Page ID: ' + id);
    }

    // Delete page
    async function deletePage(id) {
      if (!confirm('Are you sure you want to delete this page?')) return;

      try {
        const response = await fetch(`/api/pages/${id}`, {
          method: 'DELETE'
        });

        if (!response.ok) throw new Error('Failed to delete page');

        loadPages();
      } catch (error) {
        alert(`Error: ${error.message}`);
      }
    }

    // Load pages on page load
    loadPages();

    // Auto-refresh pages every 5 seconds
    setInterval(loadPages, 5000);
  </script>
</body>
</html>
EOF

# Create README.md
cat > README.md << 'EOF'
# Markdown Site Builder

A simple Node.js static site generator that converts markdown files into beautiful static websites with a web UI.

## Features

- 📝 **Write in Markdown** - Create pages using markdown syntax
- 🎨 **Beautiful UI** - Clean, modern web interface for managing pages
- ⚡ **Simple API** - RESTful API for page management
- 📂 **Static Output** - Generates standalone HTML files
- 🚀 **Easy to Use** - No configuration needed, just start writing

## Quick Start

### Prerequisites

- Node.js 14+
- npm or yarn

### Installation

```bash
# Clone the repository
git clone https://github.com/talsh-port/markdown-site-builder.git
cd markdown-site-builder

# Install dependencies
npm install

# Start the development server
npm run dev
```

The application will be available at `http://localhost:3000`

## Usage

### Web UI

1. Open your browser to `http://localhost:3000`
2. Enter a page title
3. Write your content in markdown
4. Click "Create Page"
5. View all your pages in the "Your Pages" section

### API Endpoints

#### Create a Page
```bash
POST /api/pages
Content-Type: application/json

{
  "title": "My First Page",
  "content": "# Hello World\n\nThis is my first page!"
}
```

#### Get All Pages
```bash
GET /api/pages
```

#### Get a Single Page
```bash
GET /api/pages/:id
```

#### Update a Page
```bash
PUT /api/pages/:id
Content-Type: application/json

{
  "title": "Updated Title",
  "content": "Updated content..."
}
```

#### Delete a Page
```bash
DELETE /api/pages/:id
```

## Markdown Syntax

All standard markdown is supported:

```markdown
# Heading 1
## Heading 2
### Heading 3

**Bold text**
*Italic text*
~~Strikethrough~~

- Bullet list
- Second item

1. Numbered list
2. Second item

[Links](https://example.com)

`inline code`

\`\`\`
code blocks
are supported
\`\`\`

> Blockquotes work too
```

## Project Structure

```
markdown-site-builder/
├── server.js          # Express server with API routes
├── package.json       # Dependencies
├── public/
│   └── index.html     # Frontend web UI
└── output/            # Generated HTML files (auto-created)
```

## Development

```bash
# Install development dependencies
npm install --save-dev

# Run with auto-reload
npm run dev

# Run tests
npm test

# Lint code
npm run lint
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT

## Support

For issues and questions, please open an issue on GitHub.
EOF

# Initialize git, commit, and push
echo "✅ All files created successfully!"
echo ""
echo "📦 Setting up git..."
git add .
git commit -m "Initial commit: scaffold markdown site builder project

- Express server with REST API for page management
- Frontend web UI for creating and managing pages
- Markdown to HTML conversion with marked library
- Support for CRUD operations on pages
- Beautiful responsive UI with gradient design

Co-Authored-By: Claude Haiku 4.5 <noreply@anthropic.com>"

echo "🚀 Pushing to GitHub..."
git push -u origin main

echo ""
echo "✨ Setup complete! Next steps:"
echo "   1. npm install"
echo "   2. npm run dev"
echo "   3. Open http://localhost:3000"
echo ""
echo "🎉 Your markdown-site-builder is ready to go!"
EOF
chmod +x /tmp/setup-markdown-site-builder.sh
cat /tmp/setup-markdown-site-builder.sh
