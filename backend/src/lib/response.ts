export function successResponse<T>(data: T) {
  return {
    success: true,
    data,
  };
}

export interface PaginationMeta {
  page: number;
  limit: number;
  total: number;
  hasMore: boolean;
}

export function paginatedResponse<T>(data: T[], meta: PaginationMeta) {
  return {
    success: true,
    data,
    pagination: meta,
  };
}

export function errorResponse(code: string, message: string, details?: unknown) {
  return {
    success: false,
    error: {
      code,
      message,
      details,
    },
  };
}
