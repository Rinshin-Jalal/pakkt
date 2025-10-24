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
  createInviteCodeHandler,
  listInviteCodesHandler,
  validateInviteCodeHandler,
  useInviteCodeHandler,
  deactivateInviteCodeHandler,
  deleteInviteCodeHandler,
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

// Member management (DEPRECATED - use invite codes instead)
packs.post('/:id/members', addMemberHandler);
packs.delete('/:id/members/:userId', removeMemberHandler);

// Pack stats
packs.get('/:id/stats', getPackStatsHandler);

// Invite codes
packs.post('/:id/invite-codes', createInviteCodeHandler);
packs.get('/:id/invite-codes', listInviteCodesHandler);
packs.patch('/:id/invite-codes/:codeId/deactivate', deactivateInviteCodeHandler);
packs.delete('/:id/invite-codes/:codeId', deleteInviteCodeHandler);

export default packs;
