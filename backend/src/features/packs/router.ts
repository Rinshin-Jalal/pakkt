import { Hono } from 'hono';
import { requireAuth } from '../../middleware/auth';
import {
  createPackHandler,
  getUserPacksHandler,
  getPackHandler,
  updatePackHandler,
  dissolvePackHandler,
  addMemberHandler,
  removeMemberHandler,
  getPackStatsHandler,
} from './routes';
import type { Env } from '../../types/env';

const packs = new Hono<{ Bindings: Env }>();

// All pack routes require authentication
packs.use('*', requireAuth);

// Pack CRUD
packs.post('/', createPackHandler);
packs.get('/', getUserPacksHandler);
packs.get('/:id', getPackHandler);
packs.patch('/:id', updatePackHandler);
packs.delete('/:id', dissolvePackHandler);

// Member management
packs.post('/:id/members', addMemberHandler);
packs.delete('/:id/members/:userId', removeMemberHandler);

// Pack stats
packs.get('/:id/stats', getPackStatsHandler);

export default packs;
