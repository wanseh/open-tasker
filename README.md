# OpenTasker

A modern task management and project collaboration platform built with Next.js, NestJS, and TypeScript.

## 🚀 Features

- **Task Management**: Create, assign, and track tasks with status and priority
- **Project Organization**: Organize tasks into projects with team collaboration
- **Real-time Updates**: WebSocket-powered real-time notifications and updates
- **AI Integration**: Smart task suggestions and priority recommendations
- **Team Collaboration**: Role-based permissions and team management
- **File Attachments**: Upload and manage files within tasks
- **Time Tracking**: Track time spent on tasks
- **Mobile Responsive**: Works seamlessly on desktop and mobile devices

## 🏗️ Architecture

- **Frontend**: Next.js 14 with App Router, TypeScript, Tailwind CSS
- **Backend**: NestJS with TypeScript, PostgreSQL, Redis
- **Database**: PostgreSQL for data persistence
- **Cache**: Redis for session management and caching
- **Real-time**: WebSocket for live updates
- **AI**: OpenAI integration for smart features
- **Deployment**: Docker containers with Docker Compose

## 📦 Tech Stack

### Frontend
- Next.js 14
- TypeScript
- Tailwind CSS
- Zustand (State Management)
- React Hook Form
- Zod (Validation)

### Backend
- NestJS
- TypeScript
- PostgreSQL (TypeORM)
- Redis
- JWT Authentication
- WebSocket (Socket.io)

### DevOps
- Docker & Docker Compose
- GitHub Actions (CI/CD)
- Turborepo (Monorepo)
- pnpm (Package Manager)

## 🚀 Quick Start

### Prerequisites

- Node.js 18+
- pnpm 8+
- Docker & Docker Compose
- PostgreSQL 15+
- Redis 7+

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/open-tasker.git
   cd open-tasker
   ```

2. **Install dependencies**
   ```bash
   pnpm install
   ```

3. **Set up environment**
   ```bash
   cp .env.example .env
   # Update .env with your configuration
   ```

4. **Start development environment**
   ```bash
   ./scripts/setup-dev.sh
   ```

5. **Start the applications**
   ```bash
   # Start backend
   pnpm dev:backend
   
   # Start frontend (in another terminal)
   pnpm dev:frontend
   ```

6. **Open your browser**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:3001

## 📁 Project Structure

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

## 🛠️ Development

### Available Scripts

```bash
# Install dependencies
pnpm install

# Development
pnpm dev:frontend          # Start frontend dev server
pnpm dev:backend           # Start backend dev server

# Building
pnpm build                 # Build all packages
pnpm build:frontend        # Build frontend
pnpm build:backend         # Build backend

# Testing
pnpm test                  # Run all tests
pnpm test:frontend         # Test frontend
pnpm test:backend          # Test backend

# Linting
pnpm lint                  # Lint all packages
pnpm lint:fix              # Fix linting issues

# Type checking
pnpm type-check            # Type check all packages
```

### Docker Development

```bash
# Start all services
cd docker
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## 🚀 Deployment

### Production Deployment

```bash
# Deploy to production
./scripts/deploy.sh production
```

### Environment Variables

Make sure to set the following environment variables for production:

```bash
# Database
DATABASE_URL=postgresql://username:password@host:5432/opentasker
JWT_SECRET=your-super-secure-jwt-secret
NODE_ENV=production

# Frontend
NEXT_PUBLIC_API_URL=https://api.yourdomain.com

# AI Integration
OPENAI_API_KEY=your-openai-api-key
```

## 📚 Documentation

- [API Documentation](./docs/api/README.md)
- [Development Guide](./docs/development/README.md)
- [Deployment Guide](./docs/deployment/README.md)
- [User Guide](./docs/user-guide/README.md)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes
4. Run tests: `pnpm test`
5. Commit your changes: `git commit -m "feat: add your feature"`
6. Push to branch: `git push origin feature/your-feature`
7. Create a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Documentation**: [docs/](./docs/)
- **Issues**: [GitHub Issues](https://github.com/your-username/open-tasker/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-username/open-tasker/discussions)

## 🙏 Acknowledgments

- [Next.js](https://nextjs.org/) - React framework
- [NestJS](https://nestjs.com/) - Node.js framework
- [Tailwind CSS](https://tailwindcss.com/) - CSS framework
- [TypeORM](https://typeorm.io/) - Database ORM
- [OpenAI](https://openai.com/) - AI integration
