"""
Markdown Site Builder API - Python Requests Examples

This file demonstrates how to interact with the API using the requests library.

To use this script:
1. Install requests: pip install requests
2. Ensure the API server is running on http://localhost:3000
3. Run this script: python python-requests.py
"""

import requests
import json
from typing import Dict, List, Optional

API_BASE = 'http://localhost:3000/api'
TIMEOUT = 10  # seconds


class MarkdownSiteBuilderAPI:
    """Client for Markdown Site Builder API"""

    def __init__(self, base_url: str = API_BASE):
        self.base_url = base_url
        self.session = requests.Session()
        self.session.headers.update({'Content-Type': 'application/json'})

    def create_page(self, title: str, content: str) -> Dict:
        """Create a new page"""
        try:
            response = self.session.post(
                f'{self.base_url}/pages',
                json={'title': title, 'content': content},
                timeout=TIMEOUT
            )
            response.raise_for_status()
            page = response.json()
            print(f"✓ Page created: {page['title']}")
            return page
        except requests.exceptions.RequestException as e:
            print(f"✗ Error creating page: {e}")
            raise

    def get_all_pages(self) -> List[Dict]:
        """Get all pages"""
        try:
            response = self.session.get(
                f'{self.base_url}/pages',
                timeout=TIMEOUT
            )
            response.raise_for_status()
            pages = response.json()
            print(f"✓ Retrieved {len(pages)} page(s)")
            return pages
        except requests.exceptions.RequestException as e:
            print(f"✗ Error fetching pages: {e}")
            raise

    def get_page_by_id(self, page_id: str) -> Optional[Dict]:
        """Get a single page by ID"""
        try:
            response = self.session.get(
                f'{self.base_url}/pages/{page_id}',
                timeout=TIMEOUT
            )
            response.raise_for_status()
            page = response.json()
            print(f"✓ Retrieved page: {page['title']}")
            return page
        except requests.exceptions.HTTPError as e:
            if e.response.status_code == 404:
                print(f"✗ Page not found: {page_id}")
                return None
            print(f"✗ Error fetching page: {e}")
            raise
        except requests.exceptions.RequestException as e:
            print(f"✗ Error fetching page: {e}")
            raise

    def update_page(self, page_id: str, title: Optional[str] = None,
                   content: Optional[str] = None) -> Optional[Dict]:
        """Update an existing page"""
        updates = {}
        if title is not None:
            updates['title'] = title
        if content is not None:
            updates['content'] = content

        if not updates:
            print("✗ No updates provided")
            return None

        try:
            response = self.session.put(
                f'{self.base_url}/pages/{page_id}',
                json=updates,
                timeout=TIMEOUT
            )
            response.raise_for_status()
            page = response.json()
            print(f"✓ Page updated: {page['title']}")
            return page
        except requests.exceptions.HTTPError as e:
            if e.response.status_code == 404:
                print(f"✗ Page not found: {page_id}")
                return None
            print(f"✗ Error updating page: {e}")
            raise
        except requests.exceptions.RequestException as e:
            print(f"✗ Error updating page: {e}")
            raise

    def delete_page(self, page_id: str) -> bool:
        """Delete a page"""
        try:
            response = self.session.delete(
                f'{self.base_url}/pages/{page_id}',
                timeout=TIMEOUT
            )
            response.raise_for_status()
            print(f"✓ Page deleted: {page_id}")
            return True
        except requests.exceptions.HTTPError as e:
            if e.response.status_code == 404:
                print(f"✗ Page not found: {page_id}")
                return False
            print(f"✗ Error deleting page: {e}")
            raise
        except requests.exceptions.RequestException as e:
            print(f"✗ Error deleting page: {e}")
            raise

    def close(self):
        """Close the session"""
        self.session.close()


def demonstrate_workflow():
    """Complete workflow example"""
    client = MarkdownSiteBuilderAPI()

    try:
        print("=" * 50)
        print("Creating a new page...")
        print("=" * 50)
        new_page = client.create_page(
            "Python API Example",
            """# Python API Example

This page was created using Python and the requests library.

## Features
- Easy to use
- Type hints for better IDE support
- Error handling included

## Code Example

```python
import requests

response = requests.get('http://localhost:3000/api/pages')
pages = response.json()
```

This demonstrates basic API usage."""
        )

        print("\n" + "=" * 50)
        print("Fetching all pages...")
        print("=" * 50)
        all_pages = client.get_all_pages()
        for page in all_pages:
            print(f"- {page['title']} (ID: {page['id']})")

        print("\n" + "=" * 50)
        print("Fetching specific page...")
        print("=" * 50)
        page = client.get_page_by_id(new_page['id'])
        if page:
            print(f"Title: {page['title']}")
            print(f"Slug: {page['slug']}")
            print(f"Created: {page['createdAt']}")

        print("\n" + "=" * 50)
        print("Updating the page...")
        print("=" * 50)
        updated_page = client.update_page(
            new_page['id'],
            content="""# Python API Example (Updated)

This page was updated using the Python client.

## Updated Features
- Easy to use
- Type hints for better IDE support
- Error handling included
- Update capability demonstrated

## Better Code Example

```python
import requests

client = MarkdownSiteBuilderAPI()
page = client.get_page_by_id('page-id')
```

This is a more complete example."""
        )

        print("\n" + "=" * 50)
        print("Deleting the page...")
        print("=" * 50)
        if updated_page:
            client.delete_page(updated_page['id'])

        print("\n" + "=" * 50)
        print("✓ Workflow completed successfully!")
        print("=" * 50)

    except Exception as e:
        print(f"\n✗ Workflow error: {e}")
    finally:
        client.close()


def batch_create_pages():
    """Example: Create multiple pages"""
    client = MarkdownSiteBuilderAPI()

    pages_data = [
        {
            "title": "Getting Started",
            "content": "# Getting Started\n\nWelcome to our site!"
        },
        {
            "title": "About Us",
            "content": "# About Us\n\nLearn more about our company."
        },
        {
            "title": "Documentation",
            "content": "# Documentation\n\nAPI reference and guides."
        }
    ]

    try:
        print("Creating multiple pages...")
        created_pages = []
        for page_data in pages_data:
            page = client.create_page(
                page_data['title'],
                page_data['content']
            )
            created_pages.append(page)

        print(f"\n✓ Created {len(created_pages)} pages")
        return created_pages

    except Exception as e:
        print(f"✗ Error creating pages: {e}")
    finally:
        client.close()


if __name__ == "__main__":
    # Run the main workflow
    demonstrate_workflow()

    # Uncomment to run batch create example
    # batch_create_pages()
