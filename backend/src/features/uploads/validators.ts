import { z } from 'zod';
import { uuidSchema } from '../../utils/validation';

/**
 * Supported image MIME types
 */
const imageMimeTypes = ['image/jpeg', 'image/png', 'image/heic'] as const;

/**
 * Supported video MIME types
 */
const videoMimeTypes = ['video/mp4', 'video/quicktime'] as const;

/**
 * All supported MIME types
 */
const supportedMimeTypes = [...imageMimeTypes, ...videoMimeTypes] as const;

/**
 * Upload purposes
 */
const uploadPurposes = ['checkin', 'profile', 'pack', 'proof'] as const;

/**
 * Schema for presigned URL request
 */
export const presignedURLRequestSchema = z.object({
  file_type: z.enum(supportedMimeTypes, {
    errorMap: () => ({
      message: 'Invalid file type. Supported: JPEG, PNG, HEIC, MP4, MOV',
    }),
  }),
  purpose: z.enum(uploadPurposes, {
    errorMap: () => ({
      message: 'Invalid purpose. Supported: checkin, profile, pack, proof',
    }),
  }),
  pack_id: uuidSchema.optional(),
});

export type PresignedURLRequestData = z.infer<typeof presignedURLRequestSchema>;

/**
 * Schema for file key parameter
 */
export const fileKeyParamSchema = z.object({
  key: z.string().min(1, 'File key is required'),
});
