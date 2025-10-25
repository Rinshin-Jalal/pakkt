import type { SupabaseClient } from '@supabase/supabase-js';
import { sendPushNotification, sendBatchNotifications } from '../../lib/apns';
import { getNotificationTemplate } from './templates';
import { NotificationType, NotificationContext } from './types';
import { InternalError } from '../../lib/errors';

/**
 * Send notification to a single user
 */
export async function sendNotificationToUser(
  supabase: SupabaseClient,
  userId: string,
  type: NotificationType,
  context: NotificationContext
): Promise<void> {
  try {
    // Get user's push tokens
    const { data: tokens, error } = await supabase
      .from('push_tokens')
      .select('token')
      .eq('user_id', userId)
      .eq('is_active', true);

    if (error) {
      console.error('[Notifications] Error fetching push tokens:', error);
      return;
    }

    if (!tokens || tokens.length === 0) {
      console.log(`[Notifications] No push tokens for user ${userId}`);
      return;
    }

    // Generate notification content
    const template = getNotificationTemplate(type, context);

    // Send to all user's devices
    const notifications = tokens.map((t) => ({
      token: t.token,
      title: template.title,
      body: template.body,
      category: template.category,
      sound: template.sound,
      badge: template.badge,
      data: template.data,
    }));

    const results = await sendBatchNotifications(notifications);

    // Clean up invalid tokens
    if (results.invalidTokens.length > 0) {
      await supabase
        .from('push_tokens')
        .update({ is_active: false })
        .in('token', results.invalidTokens);

      console.log(
        `[Notifications] Deactivated ${results.invalidTokens.length} invalid tokens`
      );
    }

    console.log('[Notifications] Sent to user:', {
      userId,
      type,
      success: results.success,
      failed: results.failed,
    });
  } catch (error) {
    console.error('[Notifications] Error sending notification:', error);
    // Don't throw - notifications are non-critical
  }
}

/**
 * Send notification to multiple users
 */
export async function sendNotificationToUsers(
  supabase: SupabaseClient,
  userIds: string[],
  type: NotificationType,
  context: NotificationContext
): Promise<void> {
  try {
    // Get push tokens for all users
    const { data: tokens, error } = await supabase
      .from('push_tokens')
      .select('token, user_id')
      .in('user_id', userIds)
      .eq('is_active', true);

    if (error) {
      console.error('[Notifications] Error fetching push tokens:', error);
      return;
    }

    if (!tokens || tokens.length === 0) {
      console.log(`[Notifications] No push tokens for users:`, userIds);
      return;
    }

    // Generate notification content
    const template = getNotificationTemplate(type, context);

    // Send to all devices
    const notifications = tokens.map((t) => ({
      token: t.token,
      title: template.title,
      body: template.body,
      category: template.category,
      sound: template.sound,
      badge: template.badge,
      data: template.data,
    }));

    const results = await sendBatchNotifications(notifications);

    // Clean up invalid tokens
    if (results.invalidTokens.length > 0) {
      await supabase
        .from('push_tokens')
        .update({ is_active: false })
        .in('token', results.invalidTokens);

      console.log(
        `[Notifications] Deactivated ${results.invalidTokens.length} invalid tokens`
      );
    }

    console.log('[Notifications] Batch sent:', {
      type,
      userCount: userIds.length,
      deviceCount: tokens.length,
      success: results.success,
      failed: results.failed,
    });
  } catch (error) {
    console.error('[Notifications] Error sending batch notifications:', error);
    // Don't throw - notifications are non-critical
  }
}

/**
 * Send notification to pack members (excluding sender)
 */
export async function sendNotificationToPack(
  supabase: SupabaseClient,
  packId: string,
  type: NotificationType,
  context: NotificationContext,
  excludeUserId?: string
): Promise<void> {
  try {
    // Get active pack members
    let query = supabase
      .from('pack_members')
      .select('user_id')
      .eq('pack_id', packId)
      .eq('is_active', true);

    if (excludeUserId) {
      query = query.neq('user_id', excludeUserId);
    }

    const { data: members, error } = await query;

    if (error) {
      console.error('[Notifications] Error fetching pack members:', error);
      return;
    }

    if (!members || members.length === 0) {
      console.log(`[Notifications] No members in pack ${packId}`);
      return;
    }

    const userIds = members.map((m) => m.user_id);
    await sendNotificationToUsers(supabase, userIds, type, context);
  } catch (error) {
    console.error('[Notifications] Error sending pack notification:', error);
    // Don't throw - notifications are non-critical
  }
}

/**
 * Send notification to check-in author
 */
export async function sendNotificationToCheckInAuthor(
  supabase: SupabaseClient,
  checkInId: string,
  type: NotificationType,
  context: NotificationContext
): Promise<void> {
  try {
    // Get check-in author
    const { data: checkIn, error } = await supabase
      .from('check_ins')
      .select('user_id')
      .eq('id', checkInId)
      .single();

    if (error || !checkIn) {
      console.error('[Notifications] Error fetching check-in:', error);
      return;
    }

    await sendNotificationToUser(supabase, checkIn.user_id, type, context);
  } catch (error) {
    console.error(
      '[Notifications] Error sending check-in author notification:',
      error
    );
    // Don't throw - notifications are non-critical
  }
}
