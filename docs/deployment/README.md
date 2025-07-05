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