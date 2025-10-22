/**
 * Supported file types
 */
export type ImageMimeType = 'image/jpeg' | 'image/png' | 'image/heic';
export type VideoMimeType = 'video/mp4' | 'video/quicktime';
export type SupportedMimeType = ImageMimeType | VideoMimeType;

/**
 * Upload purposes
 */
export type UploadPurpose = 'checkin' | 'profile' | 'pack' | 'proof';

/**
 * Upload configuration
 */
export interface UploadConfig {
  maxImageSize: number; // In bytes
  maxVideoSize: number; // In bytes
  allowedImageTypes: ImageMimeType[];
  allowedVideoTypes: VideoMimeType[];
  presignedUrlExpiry: number; // In seconds
}

/**
 * Upload request
 */
export interface UploadRequest {
  file_type: SupportedMimeType;
  purpose: UploadPurpose;
  pack_id?: string;
}

/**
 * Presigned URL response
 */
export interface PresignedURLResponse {
  presigned_url: string;
  public_url: string;
  key: string;
  expires_in: number;
  max_size: number;
}

/**
 * File path components
 */
export interface FilePathComponents {
  userId: string;
  packId?: string;
  purpose: UploadPurpose;
  timestamp: number;
  uuid: string;
  extension: string;
}

/**
 * Upload metadata
 */
export interface UploadMetadata {
  user_id: string;
  pack_id?: string;
  purpose: UploadPurpose;
  file_type: string;
  file_size?: number;
  key: string;
  public_url: string;
  uploaded_at: string;
}
