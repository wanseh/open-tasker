# OpenTasker Development Guide

## Quick Start

### Prerequisites
- Node.js 18+ 
- pnpm 8+
- Docker & Docker Compose (optional)
- Git

### Installation

1. **Clone the repository:**
```bash
git clone <repository-url>
cd open-tasker
```

2. **Install dependencies:**
```bash
pnpm install
```

## Running the Application

### Option 1: Local Development (Recommended for development)

#### Start Backend
```bash
# From root directory
pnpm dev:backend

# Or directly from backend directory
cd backend
pnpm start:dev
```

#### Start Frontend
```bash
# From root directory  
pnpm dev:frontend

# Or directly from frontend directory
cd frontend
pnpm dev
```

#### Access the Application
- Frontend: http://localhost:3000
- Backend API: http://localhost:3001

### Option 2: Docker Development (Recommended for consistent environments)

#### Start Everything with Docker
```bash
cd docker
COMPOSE_BAKE=true docker-compose up --build
```

This starts:
- PostgreSQL database on port 5432
- Redis cache on port 6379
- Backend API on port 3001
- Frontend on port 3000

#### Start Only Databases
```bash
cd docker
docker-compose up postgres redis
```

Then run apps locally:
```bash
pnpm dev:backend
pnpm dev:frontend
```

### Option 3: Production Docker

```bash
cd docker
docker-compose -f docker-compose.prod.yml up --build
```

## Development Workflow

### Adding Dependencies

#### Frontend Dependencies
```bash
cd frontend
pnpm add <package-name>
```

#### Backend Dependencies
```bash
cd backend
pnpm add <package-name>
```

#### Shared Dependencies (in packages/shared-types)
```bash
cd packages/shared-types
pnpm add <package-name>
```

### Running Tests

#### Backend Tests
```bash
cd backend
pnpm test
pnpm test:watch
pnpm test:e2e
```

#### Frontend Tests
```bash
cd frontend
pnpm test
```

### Building for Production

#### Backend Build
```bash
cd backend
pnpm build
```

#### Frontend Build
```bash
cd frontend
pnpm build
```

#### Build Everything
```bash
# From root
pnpm build:backend
pnpm build:frontend
```

## Troubleshooting

### Common Issues

#### Port Already in Use
```bash
# Kill process on port 3000
lsof -ti:3000 | xargs kill -9

# Kill process on port 3001
lsof -ti:3001 | xargs kill -9
```

#### Docker Issues
```bash
# Clean up Docker
docker system prune -a
docker volume prune

# Rebuild without cache
docker-compose build --no-cache
```

#### pnpm Issues
```bash
# Clear pnpm cache
pnpm store prune

# Reinstall dependencies
rm -rf node_modules
pnpm install
```

### Checking Service Status

#### Backend Status
```bash
# Check if running
curl http://localhost:3001

# Check Docker logs
docker logs opentasker-backend

# Check container status
docker ps | grep backend
```

#### Frontend Status
```bash
# Check if running
curl http://localhost:3000

# Check Docker logs
docker logs opentasker-frontend
```

#### Database Status
```bash
# Check PostgreSQL
docker exec opentasker-postgres psql -U postgres -d opentasker -c "SELECT 1;"

# Check Redis
docker exec opentasker-redis redis-cli ping
```

## Environment Variables

### Backend Environment
Create `.env` file in backend directory:
```env
NODE_ENV=development
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/opentasker
REDIS_URL=redis://localhost:6379
JWT_SECRET=your-super-secret-jwt-key-here
API_PORT=3001
```

### Frontend Environment
Create `.env.local` file in frontend directory:
```env
NEXT_PUBLIC_API_URL=http://localhost:3001
```

## Project Structure

```
open-tasker/
├── apps/
│   ├── frontend/          # Next.js frontend
│   └── backend/           # NestJS backend
├── packages/
│   └── shared-types/      # Shared TypeScript types
├── docker/                # Docker configurations
├── docs/                  # Documentation
└── scripts/               # Utility scripts
```

## Useful Commands

### Development
```bash
# Start both apps in development
pnpm dev:backend & pnpm dev:frontend

# Watch for changes
pnpm --filter backend start:dev
pnpm --filter frontend dev

# Lint code
pnpm --filter backend lint
pnpm --filter frontend lint
```

### Docker
```bash
# Start development environment
cd docker && docker-compose up

# Start production environment
cd docker && docker-compose -f docker-compose.prod.yml up

# View logs
docker-compose logs -f backend
docker-compose logs -f frontend

# Execute commands in containers
docker exec -it opentasker-backend sh
docker exec -it opentasker-frontend sh
```

### Database
```bash
# Connect to PostgreSQL
docker exec -it opentasker-postgres psql -U postgres -d opentasker

# Backup database
./scripts/backup-db.sh

# Reset database
docker-compose down -v
docker-compose up postgres
```

## Contributing

1. Create a feature branch
2. Make your changes
3. Run tests: `pnpm test`
4. Build the project: `pnpm build:backend && pnpm build:frontend`
5. Submit a pull request

## Support

For issues and questions:
- Check the troubleshooting section above
- Review Docker logs for errors
- Ensure all prerequisites are installed
- Verify environment variables are set correctly 