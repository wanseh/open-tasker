#!/bin/bash

# OpenTasker Quick Start Script
# This script helps you get OpenTasker running quickly

set -e

echo "🚀 OpenTasker Quick Start"
echo "=========================="

# Check if we're in the right directory
if [ ! -f "package.json" ] || [ ! -f "pnpm-workspace.yaml" ]; then
    echo "❌ Error: Please run this script from the OpenTasker root directory"
    exit 1
fi

# Check prerequisites
echo "📋 Checking prerequisites..."

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 18+ first."
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Node.js version 18+ is required. Current version: $(node -v)"
    exit 1
fi

echo "✅ Node.js $(node -v)"

# Check pnpm
if ! command -v pnpm &> /dev/null; then
    echo "❌ pnpm is not installed. Installing pnpm..."
    npm install -g pnpm
fi

echo "✅ pnpm $(pnpm --version)"

# Check Docker (optional)
if command -v docker &> /dev/null && command -v docker-compose &> /dev/null; then
    echo "✅ Docker and Docker Compose available"
    DOCKER_AVAILABLE=true
else
    echo "⚠️  Docker not available - will use local development mode"
    DOCKER_AVAILABLE=false
fi

# Install dependencies
echo "📦 Installing dependencies..."
pnpm install

# Ask user for preferred method
echo ""
echo "How would you like to run OpenTasker?"
echo "1. Local development (recommended for development)"
echo "2. Docker development (recommended for consistent environments)"
echo "3. Just start the databases with Docker, run apps locally"

read -p "Choose an option (1-3): " choice

case $choice in
    1)
        echo "🚀 Starting local development..."
        echo ""
        echo "Starting backend..."
        pnpm dev:backend &
        BACKEND_PID=$!
        
        echo "Starting frontend..."
        pnpm dev:frontend &
        FRONTEND_PID=$!
        
        echo ""
        echo "✅ OpenTasker is starting up!"
        echo "📱 Frontend: http://localhost:3000"
        echo "🔧 Backend: http://localhost:3001"
        echo ""
        echo "Press Ctrl+C to stop all services"
        
        # Wait for user to stop
        wait $BACKEND_PID $FRONTEND_PID
        ;;
        
    2)
        if [ "$DOCKER_AVAILABLE" = false ]; then
            echo "❌ Docker is not available. Please install Docker first."
            exit 1
        fi
        
        echo "🐳 Starting Docker development environment..."
        cd docker
        COMPOSE_BAKE=true docker-compose up --build
        
        echo ""
        echo "✅ OpenTasker is running in Docker!"
        echo "📱 Frontend: http://localhost:3000"
        echo "🔧 Backend: http://localhost:3001"
        echo "🗄️  Database: localhost:5432"
        echo "🔴 Redis: localhost:6379"
        ;;
        
    3)
        if [ "$DOCKER_AVAILABLE" = false ]; then
            echo "❌ Docker is not available. Please install Docker first."
            exit 1
        fi
        
        echo "🐳 Starting databases with Docker..."
        cd docker
        docker-compose up -d postgres redis
        
        echo ""
        echo "✅ Databases are running!"
        echo "🗄️  Database: localhost:5432"
        echo "🔴 Redis: localhost:6379"
        echo ""
        echo "Now you can start the apps locally:"
        echo "  pnpm dev:backend"
        echo "  pnpm dev:frontend"
        ;;
        
    *)
        echo "❌ Invalid option. Please choose 1, 2, or 3."
        exit 1
        ;;
esac 