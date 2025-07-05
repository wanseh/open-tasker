#!/bin/bash

# OpenTasker Deployment Script

set -e

# Configuration
ENVIRONMENT=${1:-production}
DOCKER_COMPOSE_FILE="docker/docker-compose.yml"

if [ "$ENVIRONMENT" = "production" ]; then
    DOCKER_COMPOSE_FILE="docker/docker-compose.prod.yml"
fi

echo "🚀 Deploying OpenTasker to $ENVIRONMENT environment..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed."
    exit 1
fi

# Load environment variables
if [ -f .env ]; then
    echo "📝 Loading environment variables..."
    export $(cat .env | grep -v '^#' | xargs)
fi

# Build and deploy
echo "🔨 Building and deploying services..."
cd docker

# Pull latest images
docker-compose -f "$DOCKER_COMPOSE_FILE" pull

# Build and start services
docker-compose -f "$DOCKER_COMPOSE_FILE" up -d --build

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 30

# Run database migrations
echo "🗄️  Running database migrations..."
docker-compose -f "$DOCKER_COMPOSE_FILE" exec backend pnpm migration:run

# Health check
echo "🏥 Performing health check..."
if curl -f http://localhost:3001/health > /dev/null 2>&1; then
    echo "✅ Backend health check passed"
else
    echo "❌ Backend health check failed"
    exit 1
fi

if curl -f http://localhost:3000 > /dev/null 2>&1; then
    echo "✅ Frontend health check passed"
else
    echo "❌ Frontend health check failed"
    exit 1
fi

echo "✅ Deployment completed successfully!"
echo ""
echo "Services are running at:"
echo "- Frontend: http://localhost:3000"
echo "- Backend API: http://localhost:3001"
echo "- Database: localhost:5432"
echo "- Redis: localhost:6379" 