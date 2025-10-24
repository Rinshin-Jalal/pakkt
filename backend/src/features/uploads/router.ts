import { Hono } from 'hono';
import { requireAuth } from '../../middleware/auth';
import {
  generatePresignedURLHandler,
  directUploadHandler,
  deleteFileHandler,
  getUploadHistoryHandler,
  getUploadStatsHandler,
} from './routes';
import type { Env } from '../../types/env';

const uploads = new Hono<{ Bindings: Env }>();

// All upload routes require authentication
uploads.use('*', requireAuth);

// Upload operations
uploads.post('/presigned-url', generatePresignedURLHandler);
uploads.put('/direct/:key', directUploadHandler); // Direct upload to R2 via Worker
uploads.delete('/:key', deleteFileHandler);
uploads.get('/history', getUploadHistoryHandler);
uploads.get('/stats', getUploadStatsHandler);

export default uploads;
