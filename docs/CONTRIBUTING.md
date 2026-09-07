# Contributing to Markdown Site Builder

Thank you for your interest in contributing to the Markdown Site Builder! This guide will help you get started.

## Code of Conduct

We are committed to providing a welcoming and inspiring community for all. Please be respectful and constructive in your interactions.

## Ways to Contribute

### 1. Report Bugs

Found a bug? Please open a GitHub issue with:
- A clear, descriptive title
- Detailed description of the issue
- Steps to reproduce
- Expected behavior vs actual behavior
- Your environment (Node.js version, OS, etc.)
- Screenshots or logs if applicable

### 2. Suggest Features

Have an idea for an improvement? Open an issue with:
- Clear description of the feature
- Why it would be useful
- Possible implementation approach
- Any alternatives you've considered

### 3. Submit Code

### 4. Improve Documentation

Documentation improvements are always welcome:
- Fix typos or clarify explanations
- Add examples
- Improve API documentation
- Create tutorials or guides

### 5. Help Others

- Answer questions in issues
- Help debug problems
- Provide feedback on pull requests
- Improve test coverage

## Getting Started

### Prerequisites

- Node.js 14+
- npm or yarn
- Git
- A GitHub account

### Setting Up Your Development Environment

1. **Fork the repository**
   ```bash
   # Click "Fork" on GitHub
   ```

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/markdown-site-builder.git
   cd markdown-site-builder
   ```

3. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Install dependencies**
   ```bash
   npm install
   ```

5. **Start the development server**
   ```bash
   npm run dev
   ```

6. **Run linting**
   ```bash
   npm run lint
   ```

7. **Run tests**
   ```bash
   npm test
   ```

## Development Workflow

### Making Changes

1. Create a new branch for each feature/fix
2. Write clear, descriptive commit messages
3. Keep commits focused and logical
4. Test your changes thoroughly

### Code Style

We follow these style guidelines:

- **Indentation**: 2 spaces
- **Line Length**: Max 100 characters (soft), 120 (hard)
- **Naming**: 
  - Variables/functions: `camelCase`
  - Constants: `CONSTANT_CASE`
  - Classes: `PascalCase`
- **Comments**: Clear, concise, and meaningful
- **Error Handling**: Always handle errors appropriately

### Commit Messages

Write clear, descriptive commit messages:

```
Type: Brief description (50 chars max)

More detailed explanation if needed. Wrap at 72 characters.
Explain what and why, not how.

- Use bullet points for multiple changes
- Keep it organized and easy to read

Fixes #123
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests

### Pull Requests

Before submitting a PR:

1. **Update your branch**
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Run all checks**
   ```bash
   npm run lint
   npm test
   ```

3. **Create the PR** with:
   - Clear title describing the change
   - Reference to related issues (Fixes #123)
   - Description of what changed and why
   - Screenshots for UI changes if applicable

4. **Respond to review comments**
   - Be receptive to feedback
   - Discuss if you disagree
   - Make requested changes
   - Push new commits (don't force-push)

## Testing

### Running Tests

```bash
npm test
```

### Writing Tests

Tests go in `tests/` or `__tests__/` directories:

```javascript
describe('API - Pages', () => {
  describe('POST /api/pages', () => {
    it('should create a new page', async () => {
      // Arrange
      const pageData = { title: 'Test', content: '# Test' };
      
      // Act
      const response = await createPage(pageData);
      
      // Assert
      expect(response.title).toBe('Test');
      expect(response.id).toBeDefined();
    });

    it('should reject missing title', async () => {
      // Arrange
      const invalid = { content: '# No Title' };
      
      // Act & Assert
      await expect(createPage(invalid)).rejects.toThrow();
    });
  });
});
```

### Test Coverage

Aim for:
- `> 80%` line coverage
- `> 75%` branch coverage
- Tests for all public APIs
- Tests for error cases

## API Design Guidelines

### Endpoints

- Use RESTful conventions
- Use proper HTTP methods (GET, POST, PUT, DELETE)
- Use meaningful resource names
- Version if breaking changes occur

### Responses

- Consistent JSON structure
- Include relevant metadata
- Clear error messages
- Appropriate status codes

### Backwards Compatibility

- Avoid breaking changes
- Deprecate features gradually
- Document migration paths
- Maintain compatibility for 2+ major versions

## Documentation Guidelines

### Code Comments

```javascript
// ✓ Good: Explains why, not what
// Use Unix timestamps for consistent sorting across instances
const id = Date.now().toString();

// ✗ Bad: Obvious from code
// Set the id
const id = Date.now().toString();
```

### Function Documentation

```javascript
/**
 * Creates a new markdown page
 * 
 * @param {string} title - Page title (max 200 chars)
 * @param {string} content - Markdown content
 * @returns {Promise<Object>} The created page object
 * @throws {Error} If title or content is missing
 * 
 * @example
 * const page = await createPage('My Title', '# Hello');
 */
function createPage(title, content) {
  // ...
}
```

### README Sections

- Clear project description
- Quick start guide
- Feature list
- Installation instructions
- Usage examples
- API documentation
- Contributing section
- License

## Performance Considerations

- Profile before optimizing
- Minimize dependencies
- Use efficient algorithms
- Cache when appropriate
- Handle large datasets gracefully

## Security Best Practices

- Never commit secrets
- Use environment variables
- Validate all input
- Escape output appropriately
- Keep dependencies updated
- Follow OWASP guidelines

## Git Workflow

```
main (stable)
├── develop (integration)
│   ├── feature/user-auth
│   ├── feature/api-docs
│   └── fix/page-deletion
```

### Branching Strategy

- `main`: Production-ready code
- `develop`: Integration branch
- `feature/*`: New features
- `fix/*`: Bug fixes
- `docs/*`: Documentation updates

### Merging

- Use pull requests for all changes
- Require at least one review
- Keep commit history clean
- Squash related commits if needed

## Release Process

1. Update version in `package.json`
2. Update `CHANGELOG.md`
3. Create release PR
4. Merge to `main`
5. Tag the release
6. Publish to npm (if applicable)

## Common Tasks

### Adding a New Endpoint

1. Define in `server.js`
2. Add request/response types
3. Add error handling
4. Document in `API.md`
5. Add example in `examples/`
6. Add tests
7. Update OpenAPI spec

### Updating Dependencies

```bash
# Check for outdated packages
npm outdated

# Update to latest versions
npm update

# Run tests after updating
npm test
```

### Fixing a Bug

1. Create a test that reproduces the bug
2. Make the test fail to verify it works
3. Fix the bug
4. Make the test pass
5. Run all tests
6. Submit PR with the test included

### Adding Documentation

1. Create `.md` file in `docs/`
2. Add links in README
3. Use clear, helpful examples
4. Include code snippets
5. Proofread carefully

## Recognition

Contributors will be recognized:
- In the README
- In release notes
- As collaborators on GitHub

Thank you for contributing! 🎉

## Need Help?

- Check existing issues and PRs
- Read the documentation
- Ask in a new issue
- Check the discussions

## Resources

- [Node.js Best Practices](https://github.com/goldbergyoni/nodebestpractices)
- [REST API Design Guidelines](https://restfulapi.net/)
- [Express.js Guide](https://expressjs.com/guide.html)
- [Markdown Guide](https://www.markdownguide.org/)
- [Git Documentation](https://git-scm.com/doc)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Happy coding! 🚀
