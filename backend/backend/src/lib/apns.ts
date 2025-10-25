import apn from 'apn';

/**
 * APNs Notification Payload
 */
export interface PushNotification {
  token: string;
  title: string;
  body: string;
  badge?: number;
  sound?: string;
  category?: string;
  data?: Record<string, any>;
  threadId?: string;
  mutableContent?: boolean;
}

/**
 * APNs Configuration
 */
interface APNsConfig {
  keyId: string;
  teamId: string;
  key: string;
  production: boolean;
  bundleId: string;
}

/**
 * APNs Provider (singleton)
 */
class APNsProvider {
  private provider: apn.Provider | null = null;
  private config: APNsConfig | null = null;

  /**
   * Initialize APNs provider with credentials
   */
  initialize(config: APNsConfig) {
    if (this.provider) {
      return; // Already initialized
    }

    this.config = config;

    this.provider = new apn.Provider({
      token: {
        key: config.key,
        keyId: config.keyId,
        teamId: config.teamId,
      },
      production: config.production,
    });

    console.log(
      `[APNs] Initialized provider (${config.production ? 'PRODUCTION' : 'SANDBOX'})`
    );
  }

  /**
   * Send a single push notification
   */
  async send(notification: PushNotification): Promise<void> {
    if (!this.provider || !this.config) {
      throw new Error('APNs provider not initialized');
    }

    const apnNotification = new apn.Notification();

    // Alert content
    apnNotification.alert = {
      title: notification.title,
      body: notification.body,
    };

    // Badge
    if (notification.badge !== undefined) {
      apnNotification.badge = notification.badge;
    }

    // Sound (default or custom)
    apnNotification.sound = notification.sound || 'default';

    // Category for actionable notifications
    if (notification.category) {
      apnNotification.category = notification.category;
    }

    // Thread ID for grouping notifications
    if (notification.threadId) {
      apnNotification.threadId = notification.threadId;
    }

    // Mutable content (for notification service extensions)
    if (notification.mutableContent) {
      apnNotification.mutableContent = true;
    }

    // Custom data payload
    if (notification.data) {
      apnNotification.payload = notification.data;
    }

    // Topic (bundle ID)
    apnNotification.topic = this.config.bundleId;

    // Expiry (1 hour from now)
    apnNotification.expiry = Math.floor(Date.now() / 1000) + 3600;

    // Priority (10 = immediate, 5 = power considerations)
    apnNotification.priority = 10;

    try {
      const result = await this.provider.send(apnNotification, notification.token);

      // Check for failures
      if (result.failed && result.failed.length > 0) {
        const failure = result.failed[0];
        console.error('[APNs] Failed to send notification:', {
          device: failure.device,
          status: failure.status,
          response: failure.response,
        });

        // Handle invalid tokens
        if (
          failure.response &&
          (failure.response.reason === 'BadDeviceToken' ||
            failure.response.reason === 'Unregistered')
        ) {
          throw new Error(
            `INVALID_TOKEN:${failure.response.reason}:${notification.token}`
          );
        }

        throw new Error(`APNs send failed: ${failure.response?.reason || 'Unknown'}`);
      }

      console.log('[APNs] Notification sent successfully:', {
        token: notification.token.substring(0, 10) + '...',
        title: notification.title,
      });
    } catch (error) {
      console.error('[APNs] Error sending notification:', error);
      throw error;
    }
  }

  /**
   * Send multiple notifications in batch
   */
  async sendBatch(notifications: PushNotification[]): Promise<{
    success: number;
    failed: number;
    invalidTokens: string[];
  }> {
    const results = {
      success: 0,
      failed: 0,
      invalidTokens: [] as string[],
    };

    // Send all notifications in parallel
    const promises = notifications.map(async (notification) => {
      try {
        await this.send(notification);
        results.success++;
      } catch (error) {
        results.failed++;

        // Track invalid tokens for cleanup
        if (error instanceof Error && error.message.startsWith('INVALID_TOKEN:')) {
          const token = error.message.split(':')[2];
          if (token) {
            results.invalidTokens.push(token);
          }
        }
      }
    });

    await Promise.allSettled(promises);

    console.log('[APNs] Batch send complete:', results);

    return results;
  }

  /**
   * Shutdown the provider
   */
  shutdown() {
    if (this.provider) {
      this.provider.shutdown();
      this.provider = null;
      console.log('[APNs] Provider shutdown');
    }
  }
}

// Singleton instance
const apnsProvider = new APNsProvider();

/**
 * Initialize APNs from environment variables
 */
export function initializeAPNs(env: {
  APNS_KEY_ID?: string;
  APNS_TEAM_ID?: string;
  APNS_KEY?: string;
  APNS_PRODUCTION?: string;
  APNS_BUNDLE_ID?: string;
}): void {
  const keyId = env.APNS_KEY_ID;
  const teamId = env.APNS_TEAM_ID;
  const key = env.APNS_KEY;
  const production = env.APNS_PRODUCTION === 'true';
  const bundleId = env.APNS_BUNDLE_ID || 'com.pakkt.app';

  if (!keyId || !teamId || !key) {
    console.warn('[APNs] Missing credentials, push notifications disabled');
    return;
  }

  apnsProvider.initialize({
    keyId,
    teamId,
    key,
    production,
    bundleId,
  });
}

/**
 * Send a push notification
 */
export async function sendPushNotification(
  notification: PushNotification
): Promise<void> {
  return apnsProvider.send(notification);
}

/**
 * Send multiple push notifications
 */
export async function sendBatchNotifications(
  notifications: PushNotification[]
): Promise<{
  success: number;
  failed: number;
  invalidTokens: string[];
}> {
  return apnsProvider.sendBatch(notifications);
}

/**
 * Check if APNs is available
 */
export function isAPNsAvailable(): boolean {
  return apnsProvider !== null;
}
