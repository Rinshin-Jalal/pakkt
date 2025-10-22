import type { PhoneJail, JailSessionWithProgress } from './types';

/**
 * Heartbeat timeout threshold (in seconds)
 * If no heartbeat received for > 60 seconds, pause the timer
 */
export const HEARTBEAT_TIMEOUT_SECONDS = 60;

/**
 * Expected heartbeat interval (in seconds)
 */
export const HEARTBEAT_INTERVAL_SECONDS = 30;

/**
 * Check if session should be paused (no recent heartbeat)
 */
export function shouldPauseSession(lastHeartbeatAt: string): boolean {
  const now = Date.now();
  const lastHeartbeat = new Date(lastHeartbeatAt).getTime();
  const secondsSinceHeartbeat = (now - lastHeartbeat) / 1000;
  
  return secondsSinceHeartbeat > HEARTBEAT_TIMEOUT_SECONDS;
}

/**
 * Calculate elapsed time considering pauses
 */
export function calculateElapsedTime(
  startedAt: string,
  totalPausedDuration: number, // in seconds
  pausedAt?: string,
  currentTime: Date = new Date()
): number {
  const start = new Date(startedAt).getTime();
  const now = currentTime.getTime();
  
  // Total wall-clock time elapsed
  const totalElapsedMs = now - start;
  const totalElapsedSeconds = totalElapsedMs / 1000;
  
  // If currently paused, add time since pause started
  let currentPauseDuration = 0;
  if (pausedAt) {
    const pauseStart = new Date(pausedAt).getTime();
    currentPauseDuration = (now - pauseStart) / 1000;
  }
  
  // Active time = total time - (previous pauses + current pause)
  const activeSeconds = totalElapsedSeconds - totalPausedDuration - currentPauseDuration;
  
  return Math.max(0, activeSeconds);
}

/**
 * Calculate jail session progress
 */
export function calculateSessionProgress(
  session: PhoneJail,
  currentTime: Date = new Date()
): JailSessionWithProgress {
  const isPaused = session.paused_at !== undefined && session.paused_at !== null;
  
  // Calculate elapsed active time in seconds
  const elapsedSeconds = calculateElapsedTime(
    session.started_at,
    session.total_paused_duration,
    session.paused_at || undefined,
    currentTime
  );
  
  const elapsedMinutes = elapsedSeconds / 60;
  const remainingMinutes = Math.max(0, session.duration_minutes - elapsedMinutes);
  const progressPercentage = Math.min(
    100,
    (elapsedMinutes / session.duration_minutes) * 100
  );
  
  // Get original fine amount for break calculation
  const breakFineAmount = session.fine_id ? 0 : session.duration_minutes * 100; // Placeholder
  
  return {
    ...session,
    elapsed_minutes: Math.round(elapsedMinutes * 10) / 10,
    remaining_minutes: Math.round(remainingMinutes * 10) / 10,
    progress_percentage: Math.round(progressPercentage * 10) / 10,
    is_paused: isPaused,
    can_break: session.status === 'active',
    break_fine_amount: breakFineAmount * 2, // 2x the original
  };
}

/**
 * Check if session should be auto-completed
 */
export function shouldAutoComplete(
  session: PhoneJail,
  currentTime: Date = new Date()
): boolean {
  if (session.status !== 'active') {
    return false;
  }
  
  const elapsedSeconds = calculateElapsedTime(
    session.started_at,
    session.total_paused_duration,
    session.paused_at || undefined,
    currentTime
  );
  
  const elapsedMinutes = elapsedSeconds / 60;
  
  return elapsedMinutes >= session.duration_minutes;
}

/**
 * Calculate pause duration to add to total
 */
export function calculatePauseDuration(pausedAt: string, resumeTime: Date = new Date()): number {
  const pauseStart = new Date(pausedAt).getTime();
  const resumeAt = resumeTime.getTime();
  
  return Math.max(0, (resumeAt - pauseStart) / 1000);
}

/**
 * Validate blocked apps (iOS bundle IDs format)
 */
export function validateBlockedApps(apps: string[]): { valid: boolean; reason?: string } {
  if (apps.length === 0) {
    return { valid: false, reason: 'At least one app must be blocked' };
  }
  
  if (apps.length > 50) {
    return { valid: false, reason: 'Cannot block more than 50 apps' };
  }
  
  // Basic bundle ID format validation (com.company.app)
  const bundleIdPattern = /^[a-zA-Z0-9][a-zA-Z0-9-]*(\.[a-zA-Z0-9][a-zA-Z0-9-]*)+$/;
  
  for (const app of apps) {
    if (!bundleIdPattern.test(app)) {
      return { valid: false, reason: `Invalid bundle ID format: ${app}` };
    }
  }
  
  return { valid: true };
}

/**
 * Calculate break fine amount (2x original fine)
 */
export function calculateBreakFineAmount(originalFineAmount: number): number {
  return originalFineAmount * 2;
}

/**
 * Format duration for display
 */
export function formatDuration(minutes: number): string {
  const hours = Math.floor(minutes / 60);
  const mins = Math.round(minutes % 60);
  
  if (hours > 0) {
    return `${hours}h ${mins}m`;
  }
  return `${mins}m`;
}

/**
 * Get default blocked apps for common social media
 */
export function getCommonBlockedApps(): string[] {
  return [
    'com.burbn.instagram',
    'com.atebits.Tweetie2',
    'com.facebook.Facebook',
    'com.toyopagroup.picaboo', // Snapchat
    'com.zhiliaoapp.musically', // TikTok
    'net.whatsapp.WhatsApp',
    'com.google.chrome.ios',
    'com.reddit.Reddit',
  ];
}
