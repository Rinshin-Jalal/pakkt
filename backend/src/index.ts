import { Hono } from 'hono';
import { corsMiddleware } from './middleware/cors';
import { loggerMiddleware } from './middleware/logger';
import { errorHandler } from './middleware/errorHandler';
import { rateLimitMiddleware } from './middleware/rateLimit';
import { requireAuth, optionalAuth, getAuthenticatedUserId } from './middleware/auth';
import type { Env } from './types/env';

// Import feature routers
import usersRouter from './features/users/router';
import packsRouter from './features/packs/router';
import goalsRouter from './features/goals/router';
import checkinsRouter from './features/checkins/router';
import finesRouter from './features/fines/router';
import jailRouter from './features/jail/router';
import socialRouter from './features/social/router';
import uploadsRouter from './features/uploads/router';

// Import specific handlers for nested routes
import { createGoalHandler, listPackGoalsHandler } from './features/goals/routes';
import { getPackCheckInsHandler } from './features/checkins/routes';
import { listPackFinesHandler } from './features/fines/routes';
import { getReactionsHandler, getCommentsHandler } from './features/social/routes';

const app = new Hono<{ Bindings: Env }>();

// Global middleware
app.use('*', corsMiddleware);
app.use('*', loggerMiddleware);
app.use('*', rateLimitMiddleware());

// Public routes
app.get('/health', (c) => {
  return c.json({ 
    status: 'ok', 
    timestamp: new Date().toISOString(),
    version: '1.0.0' 
  });
});

// Mount feature routers
app.route('/api/users', usersRouter);
app.route('/api/packs', packsRouter);
app.route('/api/goals', goalsRouter);
app.route('/api/checkins', checkinsRouter);
app.route('/api/fines', finesRouter);
app.route('/api/jail', jailRouter);
app.route('/api/social', socialRouter);
app.route('/api/uploads', uploadsRouter);

// Pack-nested routes
app.post('/api/packs/:packId/goals', requireAuth, createGoalHandler);
app.get('/api/packs/:packId/goals', requireAuth, listPackGoalsHandler);
app.get('/api/packs/:packId/checkins', requireAuth, getPackCheckInsHandler);
app.get('/api/packs/:packId/fines', requireAuth, listPackFinesHandler);

// Check-in nested routes (reactions & comments)
app.get('/api/checkins/:checkInId/reactions', requireAuth, getReactionsHandler);
app.get('/api/checkins/:checkInId/comments', requireAuth, getCommentsHandler);

// Protected routes (examples for testing)
app.get('/api/me', requireAuth, (c) => {
  const userId = getAuthenticatedUserId(c);
  const email = c.get('userEmail');
  
  return c.json({
    success: true,
    data: {
      userId,
      email,
    },
  });
});

// Optional auth example
app.get('/api/feed', optionalAuth, (c) => {
  const userId = c.get('userId');
  
  return c.json({
    success: true,
    data: {
      authenticated: !!userId,
      userId: userId || null,
      message: userId ? 'Personalized feed' : 'Public feed',
    },
  });
});

// Error handling
app.onError(errorHandler);

export default app;
