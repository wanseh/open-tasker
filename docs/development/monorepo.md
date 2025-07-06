# OpenTasker Monorepo Guide

## What is a Monorepo?

A **monorepo** is a single repository that contains multiple related projects/packages. Instead of having separate repositories for frontend, backend, and shared code, everything lives in one place with unified tooling and dependency management.

## Why Monorepo?

### Benefits
- **Shared Code**: Types, utilities, and configurations shared across packages
- **Atomic Changes**: Update multiple packages in a single commit
- **Simplified Development**: One command to install, build, and test everything
- **Better Tooling**: Unified linting, formatting, and CI/CD
- **Dependency Management**: Automatic hoisting and deduplication
- **Cross-Package Refactoring**: Easier to refactor across boundaries

### Trade-offs
- **Repository Size**: Larger repository with more files
- **Build Complexity**: More complex build pipelines
- **Learning Curve**: Developers need to understand monorepo concepts

## OpenTasker Monorepo Architecture

### Directory Structure 

```
opentasker/ # Root monorepo
├── package.json # Workspace manager
├── pnpm-workspace.yaml # Workspace configuration
├── turbo.json # Build pipeline configuration
├── pnpm-lock.yaml # Lock file for all dependencies
├── apps/ # Applications
│ ├── frontend/ # Next.js application
│ │ ├── package.json
│ │ ├── src/
│ │ └── ...
│ └── backend/ # NestJS API
│ ├── package.json
│ ├── src/
│ └── ...
├── packages/ # Shared libraries
│ ├── shared-types/ # TypeScript type definitions
│ │ ├── package.json
│ │ ├── src/
│ │ └── dist/
│ └── eslint-config/ # Shared ESLint configuration
│ ├── package.json
│ └── index.js
├── docker/ # Docker configurations
├── scripts/ # Utility scripts
└── docs/ # Documentation
```

## Key Configuration Files

### 1. `pnpm-workspace.yaml` - Workspace Definition
```yaml
packages:
  - apps/*
  - packages/*

ignoredBuiltDependencies:
  - '@nestjs/core'
  - '@tailwindcss/oxide'
  - es5-ext
  - fsevents
  - sharp
  - unrs-resolver
```

This file tells pnpm:
- Look for packages in `apps/` directory (applications)
- Look for packages in `packages/` directory (shared libraries)
- Look for packages in `scripts/` directory (utility scripts)
- Look for packages in `docker/` directory (Docker configs)
- Each subdirectory with a `package.json` is a workspace package
- `ignoredBuiltDependencies` prevents hoisting of problematic packages

### 2. Root `package.json` - Workspace Manager
```json
{
  "name": "open-tasker",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "dev:frontend": "pnpm --filter frontend dev",
    "dev:backend": "pnpm --filter backend start:dev",
    "build:frontend": "pnpm --filter frontend build",
    "build:backend": "pnpm --filter backend build"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "packageManager": "pnpm@10.12.4"
}
```

- Uses `--filter` to run commands on specific packages
- `packageManager` ensures consistent pnpm version
- Root scripts provide convenient shortcuts for common operations

### 3. `turbo.json` - Build Pipeline
```json
{
  "$schema": "https://turbo.build/schema.json",
  "globalDependencies": ["**/.env.*local"],
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": [".next/**", "!.next/cache/**", "dist/**"]
    },
    "lint": {
      "dependsOn": ["^lint"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "test": {
      "dependsOn": ["^build"],
      "outputs": ["coverage/**"]
    },
    "type-check": {
      "dependsOn": ["^type-check"]
    }
  }
}
```

- Defines build dependencies and outputs
- Enables parallel builds and caching
- `"^build"` = build dependencies first
- `globalDependencies` = files that invalidate all caches when changed

## Package Dependencies

### Cross-Package Dependencies
```json
// apps/frontend/package.json
{
  "dependencies": {
    "@opentasker/shared-types": "workspace:*"
  }
}

// apps/backend/package.json
{
  "dependencies": {
    "@opentasker/shared-types": "workspace:*"
  }
}
```

- `workspace:*` = use the package from this workspace
- No need to publish to npm - direct local dependency
- Version is always in sync

### Shared Package Example
```json
// packages/shared-types/package.json
{
  "name": "@opentasker/shared-types",
  "version": "1.0.0",
  "description": "Shared TypeScript types for OpenTasker",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch",
    "clean": "rm -rf dist"
  },
  "keywords": ["typescript", "types", "shared"],
  "author": "",
  "license": "MIT",
  "devDependencies": {
    "typescript": "^5.0.0"
  }
}
```

## Development Workflow

### Installation
```bash
# Install all dependencies for all packages
pnpm install
```

### Development Commands
```bash
# Start frontend development server
pnpm dev:frontend

# Start backend development server
pnpm dev:backend

# Build shared packages
pnpm --filter @opentasker/shared-types build

# Run development in watch mode
pnpm --filter @opentasker/shared-types dev
```

### Building
```bash
# Build all packages
pnpm build

# Build specific package
pnpm --filter frontend build
pnpm --filter backend build
pnpm --filter @opentasker/shared-types build
```

### Testing
```bash
# Test all packages
pnpm test

# Test specific package
pnpm --filter frontend test
pnpm --filter backend test
```

### Linting
```bash
# Lint all packages
pnpm lint

# Lint specific package
pnpm --filter frontend lint
pnpm --filter backend lint
```

## Package Management

### Adding Dependencies
```bash
# Add dependency to specific package
pnpm --filter frontend add react
pnpm --filter backend add @nestjs/core

# Add dev dependency
pnpm --filter frontend add -D typescript

# Add workspace dependency
pnpm --filter frontend add @opentasker/shared-types@workspace:*
```

### Removing Dependencies
```bash
# Remove dependency from specific package
pnpm --filter frontend remove react
```

### Updating Dependencies
```bash
# Update all dependencies
pnpm update

# Update specific package
pnpm --filter frontend update react
```

## Build Pipeline with Turborepo

### How It Works
1. **Dependency Analysis**: Turbo analyzes package dependencies
2. **Parallel Execution**: Builds packages in parallel when possible
3. **Caching**: Caches build outputs for faster rebuilds
4. **Incremental Builds**: Only rebuilds what changed

### Build Order Example
```
shared-types (build) → frontend (build)
                   ↘ backend (build)
```
- `shared-types` builds first (no dependencies)
- `frontend` and `backend` build in parallel (both depend on shared-types)

### Cache Invalidation
- Cache is invalidated when dependencies change
- Cache is invalidated when build configuration changes
- Cache can be cleared with `pnpm turbo clean`

## Adding New Packages

### 1. Create Package Directory
```bash
mkdir packages/new-package
cd packages/new-package
```

### 2. Initialize Package
```bash
pnpm init
```

### 3. Configure Package
```json
{
  "name": "@opentasker/new-package",
  "version": "1.0.0",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch"
  }
}
```

### 4. Add to Workspace
The package is automatically included because of `packages/*` in `pnpm-workspace.yaml`.

### 5. Use in Other Packages
```json
{
  "dependencies": {
    "@opentasker/new-package": "workspace:*"
  }
}
```

## CI/CD Integration

### GitHub Actions Workflow
```yaml
# .github/workflows/ci.yml
- name: Install dependencies
  run: pnpm install

- name: Build shared packages
  run: pnpm --filter @opentasker/shared-types build

- name: Lint all packages
  run: pnpm lint

- name: Test all packages
  run: pnpm test

- name: Build all packages
  run: pnpm build
```

### Deployment Workflows
- Separate workflows for frontend and backend deployment
- Path-based triggers to only deploy changed packages
- Shared build steps for consistency

## Best Practices

### 1. Package Naming
- Use scoped names: `@opentasker/package-name`
- Keep names descriptive and consistent
- Use kebab-case for package names

### 2. Dependencies
- Use `workspace:*` for internal dependencies
- Keep external dependencies minimal in shared packages
- Use exact versions for critical dependencies

### 3. Build Configuration
- Keep build outputs consistent (`dist/` for libraries)
- Use TypeScript for type safety across packages
- Configure proper entry points (`main`, `types`, `exports`)

### 4. Development
- Use `--filter` for package-specific commands
- Use `--recursive` for workspace-wide commands
- Keep package.json scripts consistent across packages

### 5. Testing
- Test packages in isolation
- Use shared test utilities when possible
- Run tests before publishing

## Troubleshooting

### Common Issues

#### Package Not Found
```bash
# Error: No projects matched the filters
```
**Solution**: Check `pnpm-workspace.yaml` includes the correct paths.

#### Build Dependencies
```bash
# Error: Cannot find module '@opentasker/shared-types'
```
**Solution**: Ensure shared package is built before dependent packages.

#### Cache Issues
```bash
# Clear turbo cache
pnpm turbo clean

# Clear pnpm cache
pnpm store prune
```

#### Version Conflicts
```bash
# Check for duplicate dependencies
pnpm why package-name

# Update lock file
pnpm install --force
```

## Migration from Separate Repos

### Step 1: Consolidate Repositories
1. Create monorepo structure
2. Move existing projects to `apps/`
3. Extract shared code to `packages/`

### Step 2: Update Dependencies
1. Replace external package references with `workspace:*`
2. Update import paths
3. Test all functionality

### Step 3: Update CI/CD
1. Consolidate workflows
2. Update build scripts
3. Test deployment pipeline

### Step 4: Team Training
1. Document monorepo concepts
2. Update development workflows
3. Establish coding standards

## Resources

- [pnpm Workspaces](https://pnpm.io/workspaces)
- [Turborepo Documentation](https://turbo.build/repo/docs)
- [Monorepo Best Practices](https://monorepo.tools/)
- [TypeScript Project References](https://www.typescriptlang.org/docs/handbook/project-references.html)