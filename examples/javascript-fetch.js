/**
 * Markdown Site Builder API - JavaScript Fetch Examples
 *
 * This file demonstrates how to interact with the API using the Fetch API
 */

const API_BASE = 'http://localhost:3000/api';

/**
 * Create a new page
 */
async function createPage(title, content) {
  try {
    const response = await fetch(`${API_BASE}/pages`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ title, content })
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'Failed to create page');
    }

    const page = await response.json();
    console.log('Page created:', page);
    return page;
  } catch (error) {
    console.error('Error creating page:', error);
    throw error;
  }
}

/**
 * Get all pages
 */
async function getAllPages() {
  try {
    const response = await fetch(`${API_BASE}/pages`);

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'Failed to fetch pages');
    }

    const pages = await response.json();
    console.log('Pages:', pages);
    return pages;
  } catch (error) {
    console.error('Error fetching pages:', error);
    throw error;
  }
}

/**
 * Get a single page by ID
 */
async function getPageById(pageId) {
  try {
    const response = await fetch(`${API_BASE}/pages/${pageId}`);

    if (!response.ok) {
      if (response.status === 404) {
        console.warn('Page not found');
        return null;
      }
      const error = await response.json();
      throw new Error(error.error || 'Failed to fetch page');
    }

    const page = await response.json();
    console.log('Page:', page);
    return page;
  } catch (error) {
    console.error('Error fetching page:', error);
    throw error;
  }
}

/**
 * Update a page
 */
async function updatePage(pageId, updates) {
  try {
    const response = await fetch(`${API_BASE}/pages/${pageId}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(updates)
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'Failed to update page');
    }

    const page = await response.json();
    console.log('Page updated:', page);
    return page;
  } catch (error) {
    console.error('Error updating page:', error);
    throw error;
  }
}

/**
 * Delete a page
 */
async function deletePage(pageId) {
  try {
    const response = await fetch(`${API_BASE}/pages/${pageId}`, {
      method: 'DELETE'
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'Failed to delete page');
    }

    const result = await response.json();
    console.log('Page deleted:', result);
    return result;
  } catch (error) {
    console.error('Error deleting page:', error);
    throw error;
  }
}

/**
 * Complete workflow example
 */
async function demonstrateWorkflow() {
  try {
    console.log('=== Creating a new page ===');
    const newPage = await createPage(
      'Getting Started with JavaScript',
      `# Getting Started with JavaScript

JavaScript is a versatile programming language.

## Features
- Dynamic typing
- First-class functions
- Prototypal inheritance

## Example

\`\`\`javascript
console.log('Hello, World!');
\`\`\`

This is a simple example of JavaScript.`
    );

    console.log('\n=== Fetching all pages ===');
    await getAllPages();

    console.log('\n=== Fetching specific page ===');
    await getPageById(newPage.id);

    console.log('\n=== Updating the page ===');
    await updatePage(newPage.id, {
      content: `# Getting Started with JavaScript

JavaScript is a versatile programming language that runs in browsers.

## Features
- Dynamic typing
- First-class functions
- Prototypal inheritance
- Async/await support

## Updated Example

\`\`\`javascript
async function greet() {
  console.log('Hello, World!');
}

greet();
\`\`\`

This is an updated example of JavaScript with async/await.`
    });

    console.log('\n=== Deleting the page ===');
    await deletePage(newPage.id);

    console.log('\n=== Workflow completed successfully ===');
  } catch (error) {
    console.error('Workflow error:', error);
  }
}

// Export functions for use as a module
if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    createPage,
    getAllPages,
    getPageById,
    updatePage,
    deletePage,
    demonstrateWorkflow
  };
}

// Uncomment to run the workflow when executing this file directly
// demonstrateWorkflow();
