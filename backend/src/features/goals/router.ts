import { Hono } from 'hono';
import { requireAuth } from '../../middleware/auth';
import {
  createGoalHandler,
  listPackGoalsHandler,
  getMyActiveGoalsHandler,
  getGoalHandler,
  getGoalStatsHandler,
  updateGoalHandler,
  deleteGoalHandler,
  toggleGoalHandler,
} from './routes';
import type { Env } from '../../types/env';

const goals = new Hono<{ Bindings: Env }>();

// All goal routes require authentication
goals.use('*', requireAuth);

// User's active goals
goals.get('/my-active', getMyActiveGoalsHandler);

// Goal CRUD
goals.get('/:id', getGoalHandler);
goals.get('/:id/stats', getGoalStatsHandler);
goals.patch('/:id', updateGoalHandler);
goals.delete('/:id', deleteGoalHandler);

// Goal status toggle
goals.post('/:id/toggle', toggleGoalHandler);

export default goals;
