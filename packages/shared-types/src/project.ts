export interface Project {
  id: string;
  name: string;
  description?: string;
  status: ProjectStatus;
  ownerId: string;
  owner: User;
  members: ProjectMember[];
  tasks: Task[];
  tags: string[];
  settings: ProjectSettings;
  createdAt: Date;
  updatedAt: Date;
}

export enum ProjectStatus {
  ACTIVE = 'active',
  ARCHIVED = 'archived',
  COMPLETED = 'completed'
}

export interface ProjectMember {
  userId: string;
  user: User;
  role: ProjectRole;
  joinedAt: Date;
}

export enum ProjectRole {
  OWNER = 'owner',
  ADMIN = 'admin',
  MEMBER = 'member',
  VIEWER = 'viewer'
}

export interface ProjectSettings {
  allowPublicAccess: boolean;
  enableTimeTracking: boolean;
  enableFileUploads: boolean;
  maxFileSize: number;
  allowedFileTypes: string[];
}

export interface CreateProjectRequest {
  name: string;
  description?: string;
  status?: ProjectStatus;
  tags?: string[];
  settings?: Partial<ProjectSettings>;
}

export interface UpdateProjectRequest {
  name?: string;
  description?: string;
  status?: ProjectStatus;
  tags?: string[];
  settings?: Partial<ProjectSettings>;
}

export interface AddMemberRequest {
  userId: string;
  role: ProjectRole;
}

// Import types that are referenced
import { User } from './auth';
import { Task } from './task'; 