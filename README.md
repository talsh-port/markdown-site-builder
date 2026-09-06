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
