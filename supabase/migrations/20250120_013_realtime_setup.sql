-- Migration 013: Real-time Setup
-- Enable real-time subscriptions for live feed, notifications, and voting

DROP PUBLICATION IF EXISTS pakkt_realtime CASCADE;
CREATE PUBLICATION pakkt_realtime FOR TABLE 
  feed_events,
  check_ins,
  fine_votes,
  notifications,
  fines,
  reactions,
  comments,
  phone_jails;

COMMENT ON PUBLICATION pakkt_realtime IS 'Real-time publication for live updates to feed, notifications, and voting';

GRANT SELECT ON feed_events TO authenticated;
GRANT SELECT ON check_ins TO authenticated;
GRANT SELECT ON fine_votes TO authenticated;
GRANT SELECT ON notifications TO authenticated;
GRANT SELECT ON fines TO authenticated;
GRANT SELECT ON reactions TO authenticated;
GRANT SELECT ON comments TO authenticated;
GRANT SELECT ON phone_jails TO authenticated;
