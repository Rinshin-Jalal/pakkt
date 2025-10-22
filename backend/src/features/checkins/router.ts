import { Hono } from 'hono';
import { requireAuth } from '../../middleware/auth';
import {
  createCheckInHandler,
  getFeedHandler,
  getCheckInHandler,
  getStatsHandler,
  deleteCheckInHandler,
} from './routes';
import type { Env } from '../../types/env';

const checkins = new Hono<{ Bindings: Env }>();

// All check-in routes require authentication
checkins.use('*', requireAuth);

// Check-in CRUD
checkins.post('/', createCheckInHandler);
checkins.get('/feed', getFeedHandler);
checkins.get('/stats', getStatsHandler);
checkins.get('/:id', getCheckInHandler);
checkins.delete('/:id', deleteCheckInHandler);

export default checkins;
