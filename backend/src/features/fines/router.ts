import { Hono } from 'hono';
import { requireAuth } from '../../middleware/auth';
import {
  createFineHandler,
  getMyFinesHandler,
  getFineHandler,
  voteHandler,
  resolveHandler,
  appealHandler,
} from './routes';
import type { Env } from '../../types/env';

const fines = new Hono<{ Bindings: Env }>();

// All fine routes require authentication
fines.use('*', requireAuth);

// Fine CRUD
fines.post('/', createFineHandler);
fines.get('/my', getMyFinesHandler);
fines.get('/:id', getFineHandler);

// Voting and resolution
fines.post('/:id/vote', voteHandler);
fines.post('/:id/resolve', resolveHandler);
fines.post('/:id/appeal', appealHandler);

export default fines;
