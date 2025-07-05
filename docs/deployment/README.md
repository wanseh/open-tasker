# OpenTasker Deployment Guide

## Overview

This guide covers deploying OpenTasker to various environments using Docker and other deployment strategies.

## Prerequisites

- Docker & Docker Compose
- PostgreSQL 15+
- Redis 7+
- Domain name (for production)
- SSL certificate (for production)

## Environment Configuration

### 1. Environment Variables

Copy and configure the environment file:

```bash
cp .env.example .env
```

Update the following variables for production:

```bash
# Database
DATABASE_URL=postgresql://username:password@host:5432/opentasker
DATABASE_HOST=your-db-host
DATABASE_PORT=5432
DATABASE_NAME=opentasker
DATABASE_USERNAME=your-username
DATABASE_PASSWORD=your-secure-password

# JWT
JWT_SECRET=your-super-secure-jwt-secret-key

# API
API_PORT=3001
API_HOST=0.0.0.0
NODE_ENV=production

# Frontend
NEXT_PUBLIC_API_URL=https://api.yourdomain.com
NEXT_PUBLIC_APP_URL=https://yourdomain.com

# AI Integration
OPENAI_API_KEY=your-openai-api-key

# WebSocket
WS_PORT=3002

# Email
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password

# Redis
REDIS_URL=redis://your-redis-host:6379
```

### 2. Database Setup

#### PostgreSQL

```bash
# Create database
createdb opentasker

# Or using Docker
docker run --name postgres \
  -e POSTGRES_DB=opentasker \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=password \
  -p 5432:5432 \
  -d postgres:15-alpine
```

#### Redis

```bash
# Using Docker
docker run --name redis \
  -p 6379:6379 \
  -d redis:7-alpine
```

## Deployment Methods

### 1. Docker Compose (Recommended)

#### Development

```bash
# Start all services
cd docker
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

#### Production

```bash
# Deploy to production
./scripts/deploy.sh production

# Or manually
cd docker
docker-compose -f docker-compose.prod.yml up -d --build
```

### 2. Manual Deployment

#### Backend

```bash
# Build backend
cd backend
pnpm build

# Start backend
NODE_ENV=production pnpm start:prod
```

#### Frontend

```bash
# Build frontend
cd frontend
pnpm build

# Start frontend
NODE_ENV=production pnpm start
```

### 3. Cloud Deployment

#### Vercel (Frontend)

1. Connect your GitHub repository to Vercel
2. Configure build settings:
   - Build Command: `pnpm build`
   - Output Directory: `.next`
   - Install Command: `pnpm install`
3. Set environment variables in Vercel dashboard
4. Deploy

#### Railway (Backend)

1. Connect your GitHub repository to Railway
2. Set environment variables
3. Configure build command: `pnpm build`
4. Set start command: `pnpm start:prod`

#### AWS ECS

1. Create ECS cluster
2. Create task definitions for frontend and backend
3. Create services
4. Configure load balancer
5. Set up auto-scaling

## SSL/HTTPS Setup

### Using Let's Encrypt

```bash
# Install certbot
sudo apt-get install certbot

# Get certificate
sudo certbot certonly --standalone -d yourdomain.com

# Configure nginx
sudo nano /etc/nginx/sites-available/opentasker
```

Nginx configuration:

```nginx
server {
    listen 80;
    server_name yourdomain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    location /api {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

## Monitoring & Logging

### Health Checks

```bash
# Check backend health
curl http://localhost:3001/health

# Check frontend
curl http://localhost:3000
```

### Logs

```bash
# View Docker logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f backend
docker-compose logs -f frontend
```

### Monitoring

Consider using:
- Prometheus + Grafana
- New Relic
- DataDog
- AWS CloudWatch

## Backup Strategy

### Database Backup

```bash
# Create backup
./scripts/backup-db.sh

# Restore backup
pg_restore -h localhost -U postgres -d opentasker backup_file.sql
```

### Automated Backups

Set up cron job for daily backups:

```bash
# Add to crontab
0 2 * * * /path/to/open-tasker/scripts/backup-db.sh
```

## Scaling

### Horizontal Scaling

```bash
# Scale backend services
docker-compose up -d --scale backend=3

# Use load balancer
docker-compose up -d nginx
```

### Database Scaling

- Use read replicas for read-heavy workloads
- Consider sharding for large datasets
- Use connection pooling (PgBouncer)

## Security

### Firewall Configuration

```bash
# Allow only necessary ports
sudo ufw allow 22    # SSH
sudo ufw allow 80    # HTTP
sudo ufw allow 443   # HTTPS
sudo ufw enable
```

### Environment Security

- Use strong passwords
- Rotate secrets regularly
- Use environment-specific configurations
- Enable audit logging

## Troubleshooting

### Common Issues

1. **Port conflicts**: Check if ports are already in use
2. **Database connection**: Verify database credentials and connectivity
3. **Memory issues**: Increase Docker memory limits
4. **SSL issues**: Check certificate validity and configuration

### Debug Commands

```bash
# Check service status
docker-compose ps

# View resource usage
docker stats

# Check network connectivity
docker network ls
docker network inspect opentasker_opentasker-network
```

## Rollback Strategy

```bash
# Rollback to previous version
git checkout <previous-tag>
./scripts/deploy.sh production

# Or rollback specific service
docker-compose -f docker-compose.prod.yml up -d --force-recreate backend
```

## Performance Optimization

1. Enable gzip compression
2. Use CDN for static assets
3. Implement caching strategies
4. Optimize database queries
5. Use connection pooling
6. Enable HTTP/2 

## Production Deployment

### Prerequisites
- Docker & Docker Compose
- PostgreSQL 15+ (or managed database)
- Redis 7+ (or managed cache)
- Domain name and SSL certificate
- Reverse proxy (nginx, traefik, etc.)

### Environment Setup

#### 1. Environment Variables

Create `.env` file in the root directory:

```env
# Database
DATABASE_URL=postgresql://username:password@host:5432/opentasker
REDIS_URL=redis://host:6379

# JWT
JWT_SECRET=your-super-secret-jwt-key-here
JWT_EXPIRES_IN=7d

# API
API_PORT=3001
API_HOST=0.0.0.0

# Frontend
NEXT_PUBLIC_API_URL=https://api.yourdomain.com

# Environment
NODE_ENV=production
```

#### 2. Database Setup

```bash
# Create database
createdb opentasker

# Run migrations (if using TypeORM)
cd apps/backend
pnpm migration:run
```

### Docker Production Deployment

#### 1. Build Production Images

```bash
cd docker
docker-compose -f docker-compose.prod.yml build
```

#### 2. Start Production Services

```bash
docker-compose -f docker-compose.prod.yml up -d
```

#### 3. Check Services

```bash
# Check all containers
docker ps

# Check logs
docker-compose -f docker-compose.prod.yml logs -f

# Test API
curl https://api.yourdomain.com/health
```

### Manual Deployment

#### 1. Backend Deployment

```bash
# Build backend
cd apps/backend
pnpm build

# Start production server
NODE_ENV=production pnpm start:prod
```

#### 2. Frontend Deployment

```bash
# Build frontend
cd apps/frontend
pnpm build

# Start production server
pnpm start
```

### Reverse Proxy Configuration

#### Nginx Example

```nginx
# Frontend
server {
    listen 80;
    server_name yourdomain.com;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}

# Backend API
server {
    listen 80;
    server_name api.yourdomain.com;
    
    location / {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### SSL Configuration

#### Using Let's Encrypt

```bash
# Install certbot
sudo apt install certbot python3-certbot-nginx

# Get SSL certificate
sudo certbot --nginx -d yourdomain.com -d api.yourdomain.com
```

### Monitoring & Logging

#### 1. Health Checks

```bash
# API health check
curl https://api.yourdomain.com/health

# Frontend health check
curl https://yourdomain.com
```

#### 2. Log Monitoring

```bash
# View application logs
docker-compose -f docker-compose.prod.yml logs -f backend
docker-compose -f docker-compose.prod.yml logs -f frontend

# View nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

#### 3. Database Monitoring

```bash
# Check database connections
docker exec opentasker-postgres psql -U postgres -d opentasker -c "SELECT count(*) FROM pg_stat_activity;"

# Check database size
docker exec opentasker-postgres psql -U postgres -d opentasker -c "SELECT pg_size_pretty(pg_database_size('opentasker'));"
```

### Backup Strategy

#### 1. Database Backup

```bash
# Create backup script
cat > backup-db.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
docker exec opentasker-postgres pg_dump -U postgres opentasker > backup_${DATE}.sql
gzip backup_${DATE}.sql
EOF

chmod +x backup-db.sh

# Run backup
./backup-db.sh
```

#### 2. Application Backup

```bash
# Backup application data
tar -czf app-backup-$(date +%Y%m%d).tar.gz \
  --exclude=node_modules \
  --exclude=.git \
  --exclude=.next \
  --exclude=dist \
  .
```

### Scaling

#### 1. Horizontal Scaling

```bash
# Scale backend services
docker-compose -f docker-compose.prod.yml up -d --scale backend=3

# Scale frontend services
docker-compose -f docker-compose.prod.yml up -d --scale frontend=2
```

#### 2. Load Balancer Configuration

```nginx
upstream backend {
    server localhost:3001;
    server localhost:3002;
    server localhost:3003;
}

upstream frontend {
    server localhost:3000;
    server localhost:3004;
}
```

### Security

#### 1. Firewall Configuration

```bash
# Allow only necessary ports
sudo ufw allow 22    # SSH
sudo ufw allow 80    # HTTP
sudo ufw allow 443   # HTTPS
sudo ufw enable
```

#### 2. Environment Security

```bash
# Use strong passwords
# Store secrets in environment variables
# Use secrets management (Docker secrets, Kubernetes secrets, etc.)
```

### Performance Optimization

#### 1. Database Optimization

```sql
-- Add indexes for frequently queried columns
CREATE INDEX idx_tasks_user_id ON tasks(user_id);
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_created_at ON tasks(created_at);
```

#### 2. Caching Strategy

```bash
# Redis configuration for caching
# Configure application-level caching
# Use CDN for static assets
```

### Troubleshooting

#### Common Issues

1. **Database Connection Issues**
```bash
# Check database status
docker exec opentasker-postgres pg_isready -U postgres

# Check connection string
echo $DATABASE_URL
```

2. **Memory Issues**
```bash
# Check memory usage
docker stats

# Increase memory limits in docker-compose
services:
  backend:
    deploy:
      resources:
        limits:
          memory: 1G
```

3. **SSL Issues**
```bash
# Check SSL certificate
openssl s_client -connect yourdomain.com:443

# Renew certificate
sudo certbot renew
```

### CI/CD Pipeline

#### GitHub Actions Example

```yaml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Build and deploy
        run: |
          cd docker
          docker-compose -f docker-compose.prod.yml build
          docker-compose -f docker-compose.prod.yml up -d
```

### Maintenance

#### Regular Tasks

1. **Weekly**
   - Check logs for errors
   - Monitor disk space
   - Review security updates

2. **Monthly**
   - Update dependencies
   - Review performance metrics
   - Test backup restoration

3. **Quarterly**
   - Security audit
   - Performance optimization
   - Infrastructure review 