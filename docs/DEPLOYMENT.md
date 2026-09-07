# Deployment Guide

This guide covers how to deploy the Markdown Site Builder API to various platforms.

## Environment Setup

### Environment Variables

Create a `.env` file in the root directory:

```env
PORT=3000
NODE_ENV=production
```

For development, you can use `.env.example` as a template.

## Deployment Platforms

### 1. Heroku

#### Prerequisites
- Heroku CLI installed
- Heroku account

#### Steps

1. **Create Heroku App**
   ```bash
   heroku create your-app-name
   ```

2. **Set Environment Variables**
   ```bash
   heroku config:set NODE_ENV=production
   heroku config:set PORT=3000
   ```

3. **Deploy**
   ```bash
   git push heroku main
   ```

4. **View Logs**
   ```bash
   heroku logs --tail
   ```

### 2. Docker

#### Create Dockerfile

```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

EXPOSE 3000

CMD ["node", "server.js"]
```

#### Create .dockerignore

```
node_modules
npm-debug.log
.git
.gitignore
README.md
.env
output/*
```

#### Build and Run

```bash
# Build the image
docker build -t markdown-site-builder .

# Run the container
docker run -p 3000:3000 -e NODE_ENV=production markdown-site-builder
```

#### Docker Compose

```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - PORT=3000
    volumes:
      - ./output:/app/output
```

Run with:
```bash
docker-compose up
```

### 3. AWS

#### Using Elastic Beanstalk

1. **Install EB CLI**
   ```bash
   pip install awsebcli --upgrade --user
   ```

2. **Initialize**
   ```bash
   eb init -p node.js-18 markdown-site-builder
   ```

3. **Create Environment**
   ```bash
   eb create production
   ```

4. **Deploy**
   ```bash
   eb deploy
   ```

#### Using EC2

1. **Launch EC2 instance** (Node.js-enabled AMI recommended)

2. **Connect to instance**
   ```bash
   ssh -i your-key.pem ec2-user@your-instance-ip
   ```

3. **Install Node.js**
   ```bash
   curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
   sudo yum install -y nodejs
   ```

4. **Clone repository**
   ```bash
   git clone https://github.com/talsh-port/markdown-site-builder.git
   cd markdown-site-builder
   ```

5. **Install dependencies**
   ```bash
   npm install
   ```

6. **Setup PM2 (process manager)**
   ```bash
   sudo npm install -g pm2
   pm2 start server.js --name "markdown-site-builder"
   pm2 startup
   pm2 save
   ```

### 4. DigitalOcean App Platform

1. **Connect GitHub repository**

2. **Create App**
   - Choose Node.js runtime
   - Set environment variables:
     - `NODE_ENV=production`
     - `PORT=3000`

3. **Configure HTTP routes**
   - Route `/` to port 3000

### 5. Railway

1. **Connect GitHub repository**

2. **Configure**
   - Select Node.js
   - Set start command: `npm start`
   - Set environment: `NODE_ENV=production`

3. **Deploy**
   - Railway automatically deploys on push

### 6. Vercel (with Serverless Functions)

Create `vercel.json`:

```json
{
  "version": 2,
  "builds": [
    {
      "src": "server.js",
      "use": "@vercel/node"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "server.js"
    }
  ]
}
```

Deploy with:
```bash
vercel deploy --prod
```

## Database Persistence

### Important: In-Memory Storage Limitation

The current implementation stores data in memory, which means:
- Data is lost when the server restarts
- Multiple instances don't share data
- Not suitable for production use

### Upgrade to Database

For production deployments, consider these options:

#### MongoDB

1. **Install mongoose**
   ```bash
   npm install mongoose
   ```

2. **Update server.js** to use MongoDB:
   ```javascript
   const mongoose = require('mongoose');
   
   mongoose.connect(process.env.MONGODB_URI);
   
   const pageSchema = new mongoose.Schema({
     title: String,
     slug: String,
     content: String,
     html: String,
     createdAt: Date,
     updatedAt: Date
   });
   
   const Page = mongoose.model('Page', pageSchema);
   ```

#### PostgreSQL

1. **Install pg**
   ```bash
   npm install pg
   ```

2. **Initialize database**
   ```bash
   createdb markdown_site_builder
   ```

3. **Create table**
   ```sql
   CREATE TABLE pages (
     id VARCHAR(50) PRIMARY KEY,
     title VARCHAR(255) NOT NULL,
     slug VARCHAR(255) NOT NULL UNIQUE,
     content TEXT NOT NULL,
     html TEXT NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
     updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
   );
   ```

## Performance Optimization

### 1. Enable Compression

Add to server.js:

```javascript
const compression = require('compression');
app.use(compression());
```

Install:
```bash
npm install compression
```

### 2. Add Caching

```javascript
app.get('/api/pages', (req, res) => {
  res.set('Cache-Control', 'public, max-age=300');
  // ... rest of endpoint
});
```

### 3. Use CDN

- Serve static files through a CDN (CloudFront, Cloudflare, etc.)
- Cache generated HTML files

### 4. Load Balancing

For multiple instances:
- Use a load balancer (nginx, HAProxy)
- Use managed load balancing from your cloud provider

## Security Checklist

- [ ] Use HTTPS in production
- [ ] Set `NODE_ENV=production`
- [ ] Use environment variables for sensitive data
- [ ] Implement API authentication
- [ ] Add rate limiting
- [ ] Validate and sanitize all inputs
- [ ] Use security headers (helmet.js)
- [ ] Keep dependencies updated: `npm audit fix`
- [ ] Use CORS appropriately
- [ ] Implement logging and monitoring

### Add Helmet for Security Headers

```bash
npm install helmet
```

In server.js:
```javascript
const helmet = require('helmet');
app.use(helmet());
```

## Monitoring & Logging

### Application Logging

```javascript
const winston = require('winston');

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' })
  ]
});

if (process.env.NODE_ENV !== 'production') {
  logger.add(new winston.transports.Console({
    format: winston.format.simple()
  }));
}
```

### Health Checks

The `/health` endpoint is already implemented. Configure your deployment to:
- Check `/health` regularly
- Restart on failure
- Log any issues

### Monitoring Services

Consider using:
- **New Relic** - Application performance monitoring
- **Datadog** - Infrastructure and application monitoring
- **Sentry** - Error tracking
- **CloudWatch** (AWS) - Logs and metrics

## Scaling

### Horizontal Scaling

For multiple instances:

1. Use a load balancer
2. Upgrade to persistent database
3. Use shared session storage if needed
4. Implement cache invalidation across instances

### Vertical Scaling

Upgrade your server:
- More CPU cores
- More RAM
- Faster storage

## Backup & Recovery

1. **Regular Backups**
   - Backup database daily
   - Store backups in multiple locations

2. **Recovery Plan**
   - Document recovery procedures
   - Test recovery regularly
   - Keep database dumps

3. **Version Control**
   - Keep all code in git
   - Tag releases
   - Maintain changelog

## DNS Configuration

1. **Purchase domain** (GoDaddy, Namecheap, etc.)

2. **Configure DNS**
   - Point to your deployment platform's DNS
   - Add CNAME or A record

3. **SSL/TLS Certificate**
   - Most platforms provide free SSL
   - Configure HTTPS redirect

## CI/CD Pipeline

### GitHub Actions Example

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Use Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run tests
        run: npm test
      
      - name: Deploy
        run: npm run deploy
        env:
          DEPLOY_TOKEN: ${{ secrets.DEPLOY_TOKEN }}
```

## Troubleshooting Deployment

### Common Issues

**Issue**: Port already in use
```bash
# Find process using port 3000
lsof -i :3000
# Kill process
kill -9 <PID>
```

**Issue**: Module not found
```bash
npm install
npm ci  # Use for production
```

**Issue**: Out of memory
```bash
# Increase Node heap size
NODE_OPTIONS="--max-old-space-size=4096" npm start
```

**Issue**: Slow startup
- Reduce number of dependencies
- Use `npm ci` instead of `npm install`
- Remove unnecessary devDependencies

## Support

For deployment issues:
1. Check platform-specific documentation
2. Review error logs
3. Check GitHub issues
4. Open a new issue if needed

Good luck with your deployment! 🚀
