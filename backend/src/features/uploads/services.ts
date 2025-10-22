import type { SupabaseClient } from '@supabase/supabase-js';
import {
  NotFoundError,
  InternalError,
  ForbiddenError,
  ValidationError,
} from '../../lib/errors';
import { generatePresignedURL, deleteObject, getPublicURL } from '../../lib/r2';
import type {
  UploadRequest,
  PresignedURLResponse,
  UploadMetadata,
} from './types';
import {
  generateFileKey,
  getMaxFileSize,
  validateFileOwnership,
  DEFAULT_UPLOAD_CONFIG,
} from './utils';

/**
 * Generate presigned URL for file upload
 */
export async function generateUploadURL(
  bucket: R2Bucket,
  supabase: SupabaseClient,
  userId: string,
  request: UploadRequest
): Promise<PresignedURLResponse> {
  // Validate pack membership if pack_id provided
  if (request.pack_id) {
    const { data: member } = await supabase
      .from('pack_members')
      .select('id')
      .eq('pack_id', request.pack_id)
      .eq('user_id', userId)
      .single();

    if (!member) {
      throw new ForbiddenError('You are not a member of this pack');
    }
  }

  // Generate file key
  const key = generateFileKey(
    userId,
    request.purpose,
    request.file_type,
    request.pack_id
  );

  // Generate presigned URL (5 minutes expiry)
  const presignedUrl = await generatePresignedURL(
    bucket,
    key,
    DEFAULT_UPLOAD_CONFIG.presignedUrlExpiry
  );

  // Generate public URL
  const publicUrl = getPublicURL('pakkt-uploads', key);

  // Get max file size for this type
  const maxSize = getMaxFileSize(request.file_type);

  // Store upload metadata in database
  await supabase.from('upload_metadata').insert({
    user_id: userId,
    pack_id: request.pack_id,
    purpose: request.purpose,
    file_type: request.file_type,
    key,
    public_url: publicUrl,
    status: 'pending',
  });

  return {
    presigned_url: presignedUrl,
    public_url: publicUrl,
    key,
    expires_in: DEFAULT_UPLOAD_CONFIG.presignedUrlExpiry,
    max_size: maxSize,
  };
}

/**
 * Delete uploaded file
 */
export async function deleteUploadedFile(
  bucket: R2Bucket,
  supabase: SupabaseClient,
  key: string,
  userId: string
): Promise<void> {
  // Validate ownership
  if (!validateFileOwnership(key, userId)) {
    throw new ForbiddenError('You can only delete your own files');
  }

  // Get metadata
  const { data: metadata } = await supabase
    .from('upload_metadata')
    .select('*')
    .eq('key', key)
    .single();

  if (!metadata) {
    throw new NotFoundError('File metadata not found');
  }

  // Verify user owns this file
  if (metadata.user_id !== userId) {
    throw new ForbiddenError('You can only delete your own files');
  }

  // Delete from R2
  try {
    await deleteObject(bucket, key);
  } catch (error) {
    console.error('R2 deletion error:', error);
    throw new InternalError('Failed to delete file from storage');
  }

  // Update metadata status
  await supabase
    .from('upload_metadata')
    .update({
      status: 'deleted',
      deleted_at: new Date().toISOString(),
    })
    .eq('key', key);
}

/**
 * Mark upload as completed (called after successful upload)
 */
export async function markUploadCompleted(
  supabase: SupabaseClient,
  key: string,
  fileSize: number
): Promise<void> {
  await supabase
    .from('upload_metadata')
    .update({
      status: 'completed',
      file_size: fileSize,
      uploaded_at: new Date().toISOString(),
    })
    .eq('key', key);
}

/**
 * Get user's upload history
 */
export async function getUserUploads(
  supabase: SupabaseClient,
  userId: string,
  limit: number = 20,
  offset: number = 0
): Promise<UploadMetadata[]> {
  const { data: uploads, error } = await supabase
    .from('upload_metadata')
    .select('*')
    .eq('user_id', userId)
    .order('created_at', { ascending: false })
    .range(offset, offset + limit - 1);

  if (error) {
    console.error('Upload history fetch error:', error);
    return [];
  }

  return (uploads || []) as UploadMetadata[];
}

/**
 * Clean up expired pending uploads (cron job helper)
 */
export async function cleanupExpiredUploads(
  bucket: R2Bucket,
  supabase: SupabaseClient
): Promise<number> {
  // Get pending uploads older than 1 hour
  const oneHourAgo = new Date(Date.now() - 60 * 60 * 1000).toISOString();

  const { data: expired } = await supabase
    .from('upload_metadata')
    .select('key')
    .eq('status', 'pending')
    .lt('created_at', oneHourAgo);

  if (!expired || expired.length === 0) {
    return 0;
  }

  let cleanedCount = 0;

  for (const upload of expired) {
    try {
      await deleteObject(bucket, upload.key);
      await supabase
        .from('upload_metadata')
        .update({ status: 'expired' })
        .eq('key', upload.key);
      cleanedCount++;
    } catch (error) {
      console.error(`Failed to cleanup ${upload.key}:`, error);
    }
  }

  return cleanedCount;
}

/**
 * Get upload statistics for user
 */
export async function getUserUploadStats(
  supabase: SupabaseClient,
  userId: string
): Promise<{
  total_uploads: number;
  total_size: number;
  by_purpose: Record<string, number>;
}> {
  const { data: uploads } = await supabase
    .from('upload_metadata')
    .select('purpose, file_size')
    .eq('user_id', userId)
    .eq('status', 'completed');

  const stats = {
    total_uploads: uploads?.length || 0,
    total_size: 0,
    by_purpose: {} as Record<string, number>,
  };

  if (uploads) {
    for (const upload of uploads) {
      stats.total_size += upload.file_size || 0;
      stats.by_purpose[upload.purpose] = (stats.by_purpose[upload.purpose] || 0) + 1;
    }
  }

  return stats;
}
