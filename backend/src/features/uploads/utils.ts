import type {
  SupportedMimeType,
  ImageMimeType,
  VideoMimeType,
  UploadPurpose,
  FilePathComponents,
  UploadConfig,
} from './types';

/**
 * Default upload configuration
 */
export const DEFAULT_UPLOAD_CONFIG: UploadConfig = {
  maxImageSize: 10 * 1024 * 1024, // 10 MB
  maxVideoSize: 50 * 1024 * 1024, // 50 MB
  allowedImageTypes: ['image/jpeg', 'image/png', 'image/heic'],
  allowedVideoTypes: ['video/mp4', 'video/quicktime'],
  presignedUrlExpiry: 300, // 5 minutes
};

/**
 * Check if MIME type is image
 */
export function isImageType(mimeType: SupportedMimeType): mimeType is ImageMimeType {
  return mimeType.startsWith('image/');
}

/**
 * Check if MIME type is video
 */
export function isVideoType(mimeType: SupportedMimeType): mimeType is VideoMimeType {
  return mimeType.startsWith('video/');
}

/**
 * Get file extension from MIME type
 */
export function getFileExtension(mimeType: SupportedMimeType): string {
  const extensions: Record<SupportedMimeType, string> = {
    'image/jpeg': 'jpg',
    'image/png': 'png',
    'image/heic': 'heic',
    'video/mp4': 'mp4',
    'video/quicktime': 'mov',
  };
  return extensions[mimeType] || 'bin';
}

/**
 * Get maximum file size for MIME type
 */
export function getMaxFileSize(
  mimeType: SupportedMimeType,
  config: UploadConfig = DEFAULT_UPLOAD_CONFIG
): number {
  return isImageType(mimeType) ? config.maxImageSize : config.maxVideoSize;
}

/**
 * Generate file path key
 * Format: {userId}/{packId?}/{purpose}/{timestamp}-{uuid}.{ext}
 */
export function generateFileKey(
  userId: string,
  purpose: UploadPurpose,
  mimeType: SupportedMimeType,
  packId?: string
): string {
  const timestamp = Date.now();
  const uuid = crypto.randomUUID();
  const extension = getFileExtension(mimeType);

  const parts = [userId];
  
  if (packId) {
    parts.push(packId);
  }
  
  parts.push(purpose);
  parts.push(`${timestamp}-${uuid}.${extension}`);

  return parts.join('/');
}

/**
 * Parse file key into components
 */
export function parseFileKey(key: string): FilePathComponents | null {
  const parts = key.split('/');
  
  // Minimum: userId/purpose/file
  if (parts.length < 3) {
    return null;
  }

  const userId = parts[0];
  let packId: string | undefined;
  let purpose: string;
  let filename: string;

  if (parts.length === 3) {
    // userId/purpose/file
    [, purpose, filename] = parts;
  } else {
    // userId/packId/purpose/file
    [, packId, purpose, filename] = parts;
  }

  // Parse filename: timestamp-uuid.ext
  const filenameParts = filename.split('.');
  if (filenameParts.length < 2) {
    return null;
  }

  const extension = filenameParts.pop()!;
  const nameWithoutExt = filenameParts.join('.');
  const [timestampStr, uuid] = nameWithoutExt.split('-');

  const timestamp = parseInt(timestampStr, 10);
  if (isNaN(timestamp)) {
    return null;
  }

  return {
    userId,
    packId,
    purpose: purpose as UploadPurpose,
    timestamp,
    uuid,
    extension,
  };
}

/**
 * Validate file key ownership
 */
export function validateFileOwnership(key: string, userId: string): boolean {
  const components = parseFileKey(key);
  if (!components) {
    return false;
  }
  return components.userId === userId;
}

/**
 * Format file size for display
 */
export function formatFileSize(bytes: number): string {
  if (bytes < 1024) {
    return `${bytes} B`;
  }
  if (bytes < 1024 * 1024) {
    return `${(bytes / 1024).toFixed(1)} KB`;
  }
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
}

/**
 * Validate MIME type is supported
 */
export function isSupportedMimeType(mimeType: string): mimeType is SupportedMimeType {
  const supported: readonly string[] = [
    'image/jpeg',
    'image/png',
    'image/heic',
    'video/mp4',
    'video/quicktime',
  ];
  return supported.includes(mimeType);
}

/**
 * Sanitize filename
 */
export function sanitizeFilename(filename: string): string {
  return filename
    .replace(/[^a-zA-Z0-9.-]/g, '_')
    .replace(/_{2,}/g, '_')
    .toLowerCase();
}

/**
 * Get content type header value
 */
export function getContentType(mimeType: SupportedMimeType): string {
  return mimeType;
}
