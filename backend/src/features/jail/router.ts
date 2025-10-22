import { Hono } from 'hono';
import { requireAuth } from '../../middleware/auth';
import {
  startJailHandler,
  getActiveSessionsHandler,
  getJailSessionHandler,
  heartbeatHandler,
  breakJailHandler,
} from './routes';
import type { Env } from '../../types/env';

const jail = new Hono<{ Bindings: Env }>();

// All jail routes require authentication
jail.use('*', requireAuth);

// Jail session management
jail.post('/start', startJailHandler);
jail.get('/active', getActiveSessionsHandler);
jail.get('/:id', getJailSessionHandler);
jail.post('/:id/heartbeat', heartbeatHandler);
jail.post('/:id/break', breakJailHandler);

export default jail;
