# OpenTasker Development Guide

## Prerequisites

- Node.js 18+ 
- pnpm 8+
- Docker & Docker Compose
- PostgreSQL 15+
- Redis 7+

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/open-tasker.git
cd open-tasker
```

### 2. Install Dependencies

```bash
pnpm install
```

### 3. Environment Setup

Copy the example environment file and configure it:

```bash
cp .env.example .env
```

Update the `.env` file with your configuration.

### 4. Start Development Services

Use the setup script to start the development environment:

```bash
./scripts/setup-dev.sh
```

Or manually start services:

```bash
# Start database and Redis
cd docker
docker-compose up -d postgres redis

# Start backend
pnpm dev:backend

# Start frontend (in another terminal)
pnpm dev:frontend
```

## Project Structure

```
opentasker/
├── apps/
│   ├── frontend/          # Next.js application
│   └── backend/           # NestJS API
├── packages/
│   ├── shared-types/      # Shared TypeScript types
│   └── eslint-config/     # Shared ESLint configuration
├── docker/                # Docker configurations
├── scripts/               # Utility scripts
└── docs/                  # Documentation
```

## Development Workflow

### 1. Code Style

We use ESLint and Prettier for code formatting. The configuration is shared in `packages/eslint-config`.

```bash
# Lint all packages
pnpm lint

# Format code
pnpm format
```

### 2. Type Checking

```bash
# Type check all packages
pnpm type-check
```

### 3. Testing

```bash
# Run all tests
pnpm test

# Run tests in watch mode
pnpm test:watch

# Run tests with coverage
pnpm test:coverage
```

### 4. Building

```bash
# Build all packages
pnpm build

# Build specific package
pnpm --filter frontend build
pnpm --filter backend build
```

## Database

### Migrations

```bash
# Generate migration
cd backend
pnpm migration:generate --name MigrationName

# Run migrations
pnpm migration:run

# Revert migration
pnpm migration:revert
```

### Seeding

```bash
# Run seeders
cd backend
pnpm seed:run
```

## API Development

### Adding New Endpoints

1. Create controller in `backend/src/[module]/[module].controller.ts`
2. Create service in `backend/src/[module]/[module].service.ts`
3. Create DTOs in `backend/src/[module]/dto/`
4. Update module in `backend/src/[module]/[module].module.ts`

### Testing API

```bash
# Start backend
pnpm dev:backend

# Test endpoints
curl http://localhost:3001/health
```

## Frontend Development

### Adding New Components

1. Create component in `frontend/src/components/[category]/`
2. Export from `frontend/src/components/[category]/index.ts`
3. Add to storybook if needed

### State Management

We use Zustand for state management:

- `frontend/src/store/authStore.ts` - Authentication state
- `frontend/src/store/taskStore.ts` - Task state
- `frontend/src/store/projectStore.ts` - Project state

### Styling

We use Tailwind CSS for styling. Custom styles can be added to:

- `frontend/src/styles/globals.css` - Global styles
- `frontend/src/styles/components.css` - Component styles

## Shared Packages

### Adding New Types

1. Add types to `packages/shared-types/src/[domain].ts`
2. Export from `packages/shared-types/src/index.ts`
3. Build the package: `pnpm --filter @opentasker/shared-types build`

### Using Shared Types

```typescript
import { User, Task, Project } from '@opentasker/shared-types';
```

## Docker Development

### Development Environment

```bash
# Start all services
cd docker
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Production Build

```bash
# Build production images
cd docker
docker-compose -f docker-compose.prod.yml build

# Deploy
docker-compose -f docker-compose.prod.yml up -d
```

## Debugging

### Backend Debugging

```bash
# Start with debugging
cd backend
pnpm start:debug
```

### Frontend Debugging

```bash
# Start with debugging
cd frontend
pnpm dev
```

Then open Chrome DevTools and use the Sources tab.

## Common Issues

### Port Conflicts

If ports are already in use:

```bash
# Find process using port
lsof -i :3000
lsof -i :3001

# Kill process
kill -9 <PID>
```

### Database Connection Issues

```bash
# Check if PostgreSQL is running
docker ps | grep postgres

# Restart database
cd docker
docker-compose restart postgres
```

### Node Modules Issues

```bash
# Clear node modules and reinstall
rm -rf node_modules
rm -rf apps/*/node_modules
rm -rf packages/*/node_modules
pnpm install
```

## Contributing

1. Create a feature branch: `git checkout -b feature/your-feature`
2. Make your changes
3. Run tests: `pnpm test`
4. Commit your changes: `git commit -m "feat: add your feature"`
5. Push to branch: `git push origin feature/your-feature`
6. Create a pull request

## Deployment

See `docs/deployment/README.md` for deployment instructions. 