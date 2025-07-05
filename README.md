# OpenTasker

A modern task management application built with Next.js, NestJS, and TypeScript in a monorepo structure.

## 🚀 Features

- **Task Management**: Create, assign, and track tasks with status and priority
- **Project Organization**: Organize tasks into projects with team collaboration
- **Real-time Updates**: WebSocket-powered real-time notifications and updates
- **AI Integration**: Smart task suggestions and priority recommendations
- **Team Collaboration**: Role-based permissions and team management
- **File Attachments**: Upload and manage files within tasks
- **Time Tracking**: Track time spent on tasks
- **Mobile Responsive**: Works seamlessly on desktop and mobile devices

## 🚀 Quick Start

### Prerequisites
- Node.js 18+
- pnpm 8+
- Docker & Docker Compose (optional)

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd open-tasker

# Install dependencies
pnpm install
```

### Running the Application

#### Option 1: Local Development (Recommended)
```bash
# Start backend
pnpm dev:backend

# Start frontend (in another terminal)
pnpm dev:frontend
```

#### Option 2: Docker Development
```bash
cd docker
COMPOSE_BAKE=true docker-compose up --build
```

#### Access the Application
- Frontend: http://localhost:3000
- Backend API: http://localhost:3001

## 📚 Documentation

- [Development Guide](docs/development/README.md) - Complete development setup and workflow
- [Deployment Guide](docs/deployment/README.md) - Production deployment instructions
- [API Documentation](docs/api/README.md) - API endpoints and usage
- [User Guide](docs/user-guide/README.md) - Application features and usage

## 🏗️ Project Structure

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

## 🛠️ Development

### Available Scripts

```bash
# Development
pnpm dev:backend          # Start backend in development
pnpm dev:frontend         # Start frontend in development

# Building
pnpm build:backend        # Build backend for production
pnpm build:frontend       # Build frontend for production

# Testing
pnpm test                 # Run all tests
```

### Adding Dependencies

```bash
# Frontend dependencies
cd frontend && pnpm add <package-name>

# Backend dependencies  
cd backend && pnpm add <package-name>

# Shared dependencies
cd packages/shared-types && pnpm add <package-name>
```

## 🐳 Docker

### Development Environment
```bash
cd docker
docker-compose up --build
```

### Production Environment
```bash
cd docker
docker-compose -f docker-compose.prod.yml up --build
```

## 🔧 Troubleshooting

### Common Issues

**Port Already in Use**
```bash
lsof -ti:3000 | xargs kill -9  # Frontend
lsof -ti:3001 | xargs kill -9  # Backend
```

**Docker Issues**
```bash
docker system prune -a
docker-compose build --no-cache
```

**pnpm Issues**
```bash
pnpm store prune
rm -rf node_modules && pnpm install
```

### Service Status

```bash
# Check if services are running
curl http://localhost:3000  # Frontend
curl http://localhost:3001  # Backend

# Check Docker containers
docker ps
```

## 📦 Tech Stack

- **Frontend**: Next.js 15, React 19, TypeScript, Tailwind CSS
- **Backend**: NestJS, TypeScript, PostgreSQL, Redis
- **Package Manager**: pnpm
- **Monorepo**: Turborepo
- **Containerization**: Docker & Docker Compose
- **Database**: PostgreSQL 15
- **Cache**: Redis 7

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests: `pnpm test`
5. Build the project: `pnpm build:backend && pnpm build:frontend`
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For issues and questions:
- Check the [troubleshooting section](docs/development/README.md#troubleshooting)
- Review Docker logs for errors
- Ensure all prerequisites are installed
- Verify environment variables are set correctly

## 🙏 Acknowledgments

- [Next.js](https://nextjs.org/) - React framework
- [NestJS](https://nestjs.com/) - Node.js framework
- [Tailwind CSS](https://tailwindcss.com/) - CSS framework
- [TypeORM](https://typeorm.io/) - Database ORM
- [OpenAI](https://openai.com/) - AI integration
