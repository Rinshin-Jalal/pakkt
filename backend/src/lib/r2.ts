/**
 * R2 client wrapper for file operations
 */

/**
 * Generate presigned URL for upload
 */
export async function generatePresignedURL(
  bucket: R2Bucket,
  key: string,
  expiresIn: number = 300 // 5 minutes
): Promise<string> {
  // Generate presigned URL for PUT operation
  const presignedUrl = await bucket.createPresignedUrl(key, {
    method: 'PUT',
    expiresIn,
  });

  return presignedUrl;
}

/**
 * Get public URL for uploaded file
 */
export function getPublicURL(bucketName: string, key: string): string {
  // Format: https://{bucket}.r2.cloudflarestorage.com/{key}
  // In production, this would use your custom domain
  return `https://${bucketName}.r2.cloudflarestorage.com/${key}`;
}

/**
 * Delete object from R2
 */
export async function deleteObject(
  bucket: R2Bucket,
  key: string
): Promise<void> {
  await bucket.delete(key);
}

/**
 * Check if object exists
 */
export async function objectExists(
  bucket: R2Bucket,
  key: string
): Promise<boolean> {
  const object = await bucket.head(key);
  return object !== null;
}

/**
 * Get object metadata
 */
export async function getObjectMetadata(
  bucket: R2Bucket,
  key: string
): Promise<R2Object | null> {
  return await bucket.head(key);
}

/**
 * List objects with prefix
 */
export async function listObjects(
  bucket: R2Bucket,
  prefix: string,
  limit: number = 100
): Promise<R2Objects> {
  return await bucket.list({
    prefix,
    limit,
  });
}
