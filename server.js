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
