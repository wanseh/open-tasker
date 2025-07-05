# OpenTasker API Documentation

## Overview

The OpenTasker API is a RESTful service built with NestJS that provides endpoints for task management, project organization, and user authentication.

## Base URL

- Development: `http://localhost:3001`
- Production: `https://api.opentasker.com`

## Authentication

The API uses JWT (JSON Web Tokens) for authentication. Include the token in the Authorization header:

```
Authorization: Bearer <your-jwt-token>
```

## Endpoints

### Authentication

#### POST /auth/register
Register a new user account.

**Request Body:**
```json
{
  "email": "user@example.com",
  "username": "username",
  "password": "password123",
  "firstName": "John",
  "lastName": "Doe"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "username": "username",
      "firstName": "John",
      "lastName": "Doe",
      "role": "user",
      "isVerified": false,
      "createdAt": "2024-01-01T00:00:00.000Z",
      "updatedAt": "2024-01-01T00:00:00.000Z"
    },
    "accessToken": "jwt-token",
    "refreshToken": "refresh-token"
  }
}
```

#### POST /auth/login
Authenticate a user and receive access tokens.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

#### POST /auth/refresh
Refresh an access token using a refresh token.

**Request Body:**
```json
{
  "refreshToken": "refresh-token"
}
```

### Users

#### GET /users/profile
Get the current user's profile.

#### PUT /users/profile
Update the current user's profile.

#### GET /users
Get all users (admin only).

### Projects

#### GET /projects
Get all projects for the current user.

#### POST /projects
Create a new project.

#### GET /projects/:id
Get a specific project.

#### PUT /projects/:id
Update a project.

#### DELETE /projects/:id
Delete a project.

#### POST /projects/:id/members
Add a member to a project.

#### DELETE /projects/:id/members/:userId
Remove a member from a project.

### Tasks

#### GET /tasks
Get all tasks for the current user.

#### POST /tasks
Create a new task.

#### GET /tasks/:id
Get a specific task.

#### PUT /tasks/:id
Update a task.

#### DELETE /tasks/:id
Delete a task.

#### POST /tasks/:id/comments
Add a comment to a task.

#### POST /tasks/:id/attachments
Upload an attachment to a task.

## Error Responses

All error responses follow this format:

```json
{
  "success": false,
  "error": "Error message",
  "statusCode": 400
}
```

## Rate Limiting

- 100 requests per minute per IP address
- 1000 requests per hour per authenticated user

## WebSocket Events

The API also provides real-time updates via WebSocket connections:

- `task:created` - New task created
- `task:updated` - Task updated
- `task:deleted` - Task deleted
- `project:updated` - Project updated
- `comment:added` - New comment added

## Status Codes

- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `422` - Validation Error
- `500` - Internal Server Error 