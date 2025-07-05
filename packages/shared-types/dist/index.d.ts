export * from './auth';
export * from './task';
export * from './project';
export interface ApiResponse<T = any> {
    success: boolean;
    data?: T;
    message?: string;
    error?: string;
}
export interface PaginatedResponse<T> {
    data: T[];
    pagination: {
        page: number;
        limit: number;
        total: number;
        totalPages: number;
    };
}
export interface ApiError {
    statusCode: number;
    message: string;
    error: string;
    timestamp: string;
    path: string;
}
