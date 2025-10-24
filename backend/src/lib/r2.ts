/**
 * R2 client wrapper for file operations
 */

/**
 * Upload file directly to R2
 * Cloudflare Workers best practice: Direct upload through Worker, not presigned URLs
 */
export async function uploadFile(
  bucket: R2Bucket,
  key: string,
  file: ReadableStream | ArrayBuffer | string | Blob,
  options?: {
    contentType?: string;
    metadata?: Record<string, string>;
  }
): Promise<R2Object> {
  const httpMetadata: R2HTTPMetadata = {};

  if (options?.contentType) {
    httpMetadata.contentType = options.contentType;
  }

  const result = await bucket.put(key, file, {
    httpMetadata,
    customMetadata: options?.metadata,
  });

  return result;
}

/**
 * Generate upload URL (returns Worker endpoint, not presigned URL)
 * Client uploads directly to Worker which proxies to R2
 */
export function generateUploadEndpoint(
  baseUrl: string,
  key: string
): { upload_url: string; key: string } {
  return {
    upload_url: `${baseUrl}/api/uploads/direct/${key}`,
    key,
  };
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
