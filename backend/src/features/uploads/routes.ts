import { Context } from 'hono';
import { getAuthenticatedUserId } from '../../middleware/auth';
import { getSupabaseClient } from '../../lib/supabase';
import { successResponse } from '../../lib/response';
import { validateBody, validateParams } from '../../utils/validation';
import {
  presignedURLRequestSchema,
  fileKeyParamSchema,
} from './validators';
import {
  generateUploadURL,
  deleteUploadedFile,
  getUserUploads,
  getUserUploadStats,
  markUploadCompleted,
} from './services';
import { uploadFile } from '../../lib/r2';

/**
 * POST /api/uploads/presigned-url
 * Generate presigned URL for file upload
 */
export async function generatePresignedURLHandler(c: Context) {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);
  const bucket = c.env.PAKKT_UPLOADS as R2Bucket;

  if (!bucket) {
    return c.json(
      {
        success: false,
        error: {
          code: 'R2_NOT_CONFIGURED',
          message: 'File uploads are not configured',
        },
      },
      500
    );
  }

  // Validate request body
  const request = await validateBody(c, presignedURLRequestSchema);

  // Generate presigned URL
  const response = await generateUploadURL(bucket, supabase, userId, request);

  return c.json(successResponse(response), 200);
}

/**
 * PUT /api/uploads/direct/:key
 * Direct upload to R2 via Worker
 */
export async function directUploadHandler(c: Context) {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);
  const bucket = c.env.PAKKT_UPLOADS as R2Bucket;
  const key = c.req.param('key');

  if (!bucket) {
    return c.json(
      {
        success: false,
        error: {
          code: 'R2_NOT_CONFIGURED',
          message: 'File uploads are not configured',
        },
      },
      500
    );
  }

  // Verify upload metadata exists and belongs to user
  const { data: metadata } = await supabase
    .from('upload_metadata')
    .select('*')
    .eq('key', key)
    .eq('user_id', userId)
    .eq('status', 'pending')
    .single();

  if (!metadata) {
    return c.json(
      {
        success: false,
        error: {
          code: 'INVALID_UPLOAD',
          message: 'Upload not found or already completed',
        },
      },
      404
    );
  }

  // Get file content type from header
  const contentType = c.req.header('content-type') || 'application/octet-stream';

  // Get file from request body
  const body = await c.req.arrayBuffer();

  // Upload to R2
  const result = await uploadFile(bucket, key, body, { contentType });

  // Mark upload as completed
  await markUploadCompleted(supabase, key, body.byteLength);

  return c.json(
    successResponse({
      message: 'File uploaded successfully',
      key,
      size: body.byteLength,
      public_url: metadata.public_url,
    }),
    201
  );
}

/**
 * DELETE /api/uploads/:key
 * Delete uploaded file
 */
export async function deleteFileHandler(c: Context) {
  const { key } = validateParams(c, fileKeyParamSchema);
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);
  const bucket = c.env.PAKKT_UPLOADS as R2Bucket;

  if (!bucket) {
    return c.json(
      {
        success: false,
        error: {
          code: 'R2_NOT_CONFIGURED',
          message: 'File uploads are not configured',
        },
      },
      500
    );
  }

  // Decode key (may be URL encoded)
  const decodedKey = decodeURIComponent(key);

  // Delete file
  await deleteUploadedFile(bucket, supabase, decodedKey, userId);

  return c.json(
    successResponse({
      message: 'File deleted successfully',
    })
  );
}

/**
 * GET /api/uploads/history
 * Get user's upload history
 */
export async function getUploadHistoryHandler(c: Context) {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Parse query params
  const limit = parseInt(c.req.query('limit') || '20');
  const offset = parseInt(c.req.query('offset') || '0');

  // Get uploads
  const uploads = await getUserUploads(supabase, userId, limit, offset);

  return c.json(successResponse(uploads));
}

/**
 * GET /api/uploads/stats
 * Get user's upload statistics
 */
export async function getUploadStatsHandler(c: Context) {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Get stats
  const stats = await getUserUploadStats(supabase, userId);

  return c.json(successResponse(stats));
}
