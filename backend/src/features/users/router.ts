import { Hono } from 'hono';
import { requireAuth } from '../../middleware/auth';
import {
  getProfile,
  updateProfile,
  addPushToken,
  removePushToken,
} from './routes';
import type { Env } from '../../types/env';

const users = new Hono<{ Bindings: Env }>();

// All user routes require authentication
users.use('*', requireAuth);

// Profile endpoints
users.get('/profile', getProfile);
users.patch('/profile', updateProfile);

// Push token endpoints
users.post('/push-token', addPushToken);
users.delete('/push-token', removePushToken);

export default users;
