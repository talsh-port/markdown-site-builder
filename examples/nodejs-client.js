/**
 * Markdown Site Builder API - Node.js Client Library
 *
 * This is a reusable Node.js client library for the Markdown Site Builder API
 *
 * Usage:
 * const { MarkdownSiteBuilderClient } = require('./nodejs-client');
 * const client = new MarkdownSiteBuilderClient();
 * const page = await client.createPage('Title', 'Content');
 */

const http = require('http');
const https = require('https');
const { URL } = require('url');

/**
 * Main client class for Markdown Site Builder API
 */
class MarkdownSiteBuilderClient {
  constructor(baseUrl = 'http://localhost:3000/api') {
    this.baseUrl = baseUrl;
    this.timeout = 10000; // 10 seconds
  }

  /**
   * Make an HTTP request to the API
   * @private
   */
  async request(method, path, data = null) {
    return new Promise((resolve, reject) => {
      const url = new URL(`${this.baseUrl}${path}`);
      const protocol = url.protocol === 'https:' ? https : http;

      const options = {
        method,
        hostname: url.hostname,
        port: url.port,
        path: url.pathname + url.search,
        headers: {
          'Content-Type': 'application/json',
        },
        timeout: this.timeout,
      };

      const req = protocol.request(options, (res) => {
        let responseData = '';

        res.on('data', (chunk) => {
          responseData += chunk;
        });

        res.on('end', () => {
          try {
            const parsed = JSON.parse(responseData);

            if (res.statusCode >= 200 && res.statusCode < 300) {
              resolve(parsed);
            } else {
              reject(new Error(parsed.error || `HTTP ${res.statusCode}`));
            }
          } catch (error) {
            reject(new Error(`Failed to parse response: ${responseData}`));
          }
        });
      });

      req.on('error', (error) => {
        reject(new Error(`Request failed: ${error.message}`));
      });

      req.on('timeout', () => {
        req.destroy();
        reject(new Error('Request timeout'));
      });

      if (data) {
        req.write(JSON.stringify(data));
      }

      req.end();
    });
  }

  /**
   * Create a new page
   * @param {string} title - Page title
   * @param {string} content - Page content (markdown)
   * @returns {Promise<Object>} Created page object
   */
  async createPage(title, content) {
    if (!title || typeof title !== 'string') {
      throw new Error('Title must be a non-empty string');
    }
    if (!content || typeof content !== 'string') {
      throw new Error('Content must be a non-empty string');
    }

    return this.request('POST', '/pages', { title, content });
  }

  /**
   * Get all pages
   * @returns {Promise<Array>} Array of page objects
   */
  async getAllPages() {
    return this.request('GET', '/pages');
  }

  /**
   * Get a single page by ID
   * @param {string} pageId - Page ID
   * @returns {Promise<Object|null>} Page object or null if not found
   */
  async getPageById(pageId) {
    try {
      return await this.request('GET', `/pages/${pageId}`);
    } catch (error) {
      if (error.message.includes('404')) {
        return null;
      }
      throw error;
    }
  }

  /**
   * Update a page
   * @param {string} pageId - Page ID
   * @param {Object} updates - Object with optional title and content fields
   * @returns {Promise<Object>} Updated page object
   */
  async updatePage(pageId, updates = {}) {
    if (!pageId || typeof pageId !== 'string') {
      throw new Error('Page ID must be a non-empty string');
    }

    const { title, content } = updates;

    if (!title && !content) {
      throw new Error('At least one of title or content must be provided');
    }

    const data = {};
    if (title) data.title = title;
    if (content) data.content = content;

    return this.request('PUT', `/pages/${pageId}`, data);
  }

  /**
   * Delete a page
   * @param {string} pageId - Page ID
   * @returns {Promise<Object>} Deletion response
   */
  async deletePage(pageId) {
    if (!pageId || typeof pageId !== 'string') {
      throw new Error('Page ID must be a non-empty string');
    }

    return this.request('DELETE', `/pages/${pageId}`);
  }

  /**
   * Create multiple pages
   * @param {Array<{title: string, content: string}>} pagesData - Array of page objects
   * @returns {Promise<Array>} Array of created pages
   */
  async createPages(pagesData) {
    if (!Array.isArray(pagesData)) {
      throw new Error('pagesData must be an array');
    }

    return Promise.all(
      pagesData.map(({ title, content }) => this.createPage(title, content))
    );
  }

  /**
   * Delete multiple pages
   * @param {Array<string>} pageIds - Array of page IDs
   * @returns {Promise<Array>} Array of deletion responses
   */
  async deletePages(pageIds) {
    if (!Array.isArray(pageIds)) {
      throw new Error('pageIds must be an array');
    }

    return Promise.all(
      pageIds.map(id => this.deletePage(id).catch(err => ({
        error: true,
        message: err.message,
        pageId: id
      })))
    );
  }

  /**
   * Search pages by title (client-side)
   * @param {string} query - Search query
   * @returns {Promise<Array>} Matching pages
   */
  async searchPages(query) {
    if (!query || typeof query !== 'string') {
      throw new Error('Query must be a non-empty string');
    }

    const pages = await this.getAllPages();
    const lowerQuery = query.toLowerCase();

    return pages.filter(page =>
      page.title.toLowerCase().includes(lowerQuery) ||
      page.content.toLowerCase().includes(lowerQuery)
    );
  }
}

/**
 * Example usage
 */
async function example() {
  const client = new MarkdownSiteBuilderClient();

  try {
    console.log('=== Creating a Page ===');
    const newPage = await client.createPage(
      'Node.js Example Page',
      `# Node.js Example

This page was created using the Node.js client library.

## Features
- Promises/async-await
- Error handling
- Batch operations

## Code

\`\`\`javascript
const client = new MarkdownSiteBuilderClient();
const page = await client.createPage('Title', 'Content');
\`\`\``
    );
    console.log('Created:', newPage);

    console.log('\n=== Getting All Pages ===');
    const pages = await client.getAllPages();
    console.log(`Found ${pages.length} page(s)`);

    console.log('\n=== Getting Specific Page ===');
    const page = await client.getPageById(newPage.id);
    console.log('Page:', page.title);

    console.log('\n=== Updating Page ===');
    const updated = await client.updatePage(newPage.id, {
      content: '# Updated\n\nThis page has been updated!'
    });
    console.log('Updated:', updated.updatedAt);

    console.log('\n=== Searching Pages ===');
    const results = await client.searchPages('Node.js');
    console.log(`Found ${results.length} matching page(s)`);

    console.log('\n=== Deleting Page ===');
    await client.deletePage(newPage.id);
    console.log('Page deleted');

    console.log('\n✓ Example completed successfully!');

  } catch (error) {
    console.error('Error:', error.message);
  }
}

// Example: Batch operations
async function batchExample() {
  const client = new MarkdownSiteBuilderClient();

  try {
    console.log('=== Batch Create Pages ===');
    const pages = await client.createPages([
      { title: 'Page 1', content: '# Page 1\n\nContent 1' },
      { title: 'Page 2', content: '# Page 2\n\nContent 2' },
      { title: 'Page 3', content: '# Page 3\n\nContent 3' }
    ]);

    console.log(`Created ${pages.length} pages`);

    const pageIds = pages.map(p => p.id);

    console.log('\n=== Batch Delete Pages ===');
    await client.deletePages(pageIds);
    console.log('Deleted all pages');

  } catch (error) {
    console.error('Error:', error.message);
  }
}

// Export the client
module.exports = { MarkdownSiteBuilderClient };

// Uncomment to run examples
// example().catch(console.error);
// batchExample().catch(console.error);
