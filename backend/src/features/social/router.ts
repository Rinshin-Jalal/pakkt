import { Hono } from 'hono';
import { requireAuth } from '../../middleware/auth';
import {
  addReactionHandler,
  removeReactionHandler,
  getReactionsHandler,
  addCommentHandler,
  editCommentHandler,
  deleteCommentHandler,
  getCommentsHandler,
  getFeedEventsHandler,
} from './routes';
import type { Env } from '../../types/env';

const social = new Hono<{ Bindings: Env }>();

// All social routes require authentication
social.use('*', requireAuth);

// Reactions
social.post('/reactions', addReactionHandler);
social.delete('/reactions/:id', removeReactionHandler);

// Comments
social.post('/comments', addCommentHandler);
social.patch('/comments/:id', editCommentHandler);
social.delete('/comments/:id', deleteCommentHandler);

// Feed events
social.get('/feed-events', getFeedEventsHandler);

// These will be mounted as nested routes in main app:
// GET /api/checkins/:checkInId/reactions
// GET /api/checkins/:checkInId/comments

export default social;
