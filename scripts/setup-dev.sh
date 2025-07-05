#!/bin/bash

# OpenTasker Development Setup Script

set -e

echo "🚀 Setting up OpenTasker development environment..."

# Check if pnpm is installed
if ! command -v pnpm &> /dev/null; then
    echo "❌ pnpm is not installed. Please install pnpm first:"
    echo "npm install -g pnpm"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "✅ Prerequisites check passed"

# Install dependencies
echo "📦 Installing dependencies..."
pnpm install

# Build shared packages
echo "🔨 Building shared packages..."
pnpm --filter @opentasker/shared-types build

# Copy environment file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file from .env.example..."
    cd .. && cp .env.example .env
    echo "⚠️  Please update .env file with your configuration"
fi

# Start development services
echo "🐳 Starting development services..."
cd docker
docker-compose up -d postgres redis

echo "⏳ Waiting for services to be ready..."
sleep 10

# Run database migrations (when backend is ready)
echo "🗄️  Running database migrations..."
cd ../backend
pnpm migration:run

echo "✅ Development environment setup complete!"
echo ""
echo "Next steps:"
echo "1. Update .env file with your configuration"
echo "2. Start the backend: pnpm dev:backend"
echo "3. Start the frontend: pnpm dev:frontend"
echo "4. Open http://localhost:3000 in your browser" 