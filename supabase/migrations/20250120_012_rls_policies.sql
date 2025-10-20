-- Migration 012: Row-Level Security (RLS) Policies
-- Comprehensive access control based on user roles and pack membership

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE packs ENABLE ROW LEVEL SECURITY;
ALTER TABLE pack_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE check_ins ENABLE ROW LEVEL SECURITY;
ALTER TABLE fines ENABLE ROW LEVEL SECURITY;
ALTER TABLE fine_votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE phone_jails ENABLE ROW LEVEL SECURITY;
ALTER TABLE punishments ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE powerups ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_powerups ENABLE ROW LEVEL SECURITY;
ALTER TABLE reactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE feed_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE challenge_rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE challenge_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE reputation_log ENABLE ROW LEVEL SECURITY;

-- USERS
CREATE POLICY "Users can read own profile" ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON users FOR UPDATE USING (auth.uid() = id);

-- PACKS
CREATE POLICY "Users can read packs they're in" ON packs FOR SELECT
  USING (auth.uid() = creator_id OR EXISTS (SELECT 1 FROM pack_members WHERE pack_id = packs.id AND user_id = auth.uid() AND is_active = true));

CREATE POLICY "Pack admins can update pack" ON packs FOR UPDATE
  USING (EXISTS (SELECT 1 FROM pack_members WHERE pack_id = packs.id AND user_id = auth.uid() AND role = 'admin'));

CREATE POLICY "Only creator can delete pack" ON packs FOR DELETE USING (auth.uid() = creator_id);

-- PACK_MEMBERS
CREATE POLICY "Users can read their pack memberships" ON pack_members FOR SELECT
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM pack_members pm WHERE pm.pack_id = pack_members.pack_id AND pm.user_id = auth.uid() AND pm.role = 'admin'));

CREATE POLICY "Admins can update pack members" ON pack_members FOR UPDATE
  USING (EXISTS (SELECT 1 FROM pack_members pm WHERE pm.pack_id = pack_members.pack_id AND pm.user_id = auth.uid() AND pm.role = 'admin'));

-- GOALS
CREATE POLICY "Pack members can read goals" ON goals FOR SELECT
  USING (EXISTS (SELECT 1 FROM pack_members WHERE pack_id = goals.pack_id AND user_id = auth.uid() AND is_active = true));

CREATE POLICY "Pack admins can manage goals" ON goals FOR UPDATE
  USING (EXISTS (SELECT 1 FROM pack_members WHERE pack_id = goals.pack_id AND user_id = auth.uid() AND role = 'admin'));

CREATE POLICY "Goal creator can delete" ON goals FOR DELETE USING (auth.uid() = creator_id);

-- CHECK_INS
CREATE POLICY "Pack members can read check-ins" ON check_ins FOR SELECT
  USING (EXISTS (SELECT 1 FROM pack_members WHERE pack_id = check_ins.pack_id AND user_id = auth.uid() AND is_active = true));

CREATE POLICY "Users can create own check-ins" ON check_ins FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own check-ins" ON check_ins FOR UPDATE USING (auth.uid() = user_id);

-- FINES
CREATE POLICY "Pack members can read fines" ON fines FOR SELECT
  USING (EXISTS (SELECT 1 FROM pack_members WHERE pack_id = fines.pack_id AND user_id = auth.uid() AND is_active = true));

CREATE POLICY "Admins can manage fines" ON fines FOR UPDATE
  USING (EXISTS (SELECT 1 FROM pack_members WHERE pack_id = fines.pack_id AND user_id = auth.uid() AND role = 'admin'));

-- FINE_VOTES
CREATE POLICY "Pack members can read fine votes" ON fine_votes FOR SELECT
  USING (EXISTS (SELECT 1 FROM fine_votes fv JOIN fines f ON fv.fine_id = f.id JOIN pack_members pm ON f.pack_id = pm.pack_id WHERE pm.user_id = auth.uid() AND pm.is_active = true AND fv.fine_id = fine_votes.fine_id));

CREATE POLICY "Pack members can vote on fines" ON fine_votes FOR INSERT
  WITH CHECK (auth.uid() = voter_id AND EXISTS (SELECT 1 FROM fines f JOIN pack_members pm ON f.pack_id = pm.pack_id WHERE pm.user_id = auth.uid() AND f.id = fine_votes.fine_id));

-- TRANSACTIONS
CREATE POLICY "Users can read own transactions" ON transactions FOR SELECT USING (auth.uid() = user_id);

-- NOTIFICATIONS
CREATE POLICY "Users can read own notifications" ON notifications FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update own notifications" ON notifications FOR UPDATE USING (auth.uid() = user_id);

-- FEED_EVENTS
CREATE POLICY "Users can read visible feed events" ON feed_events FOR SELECT
  USING (visibility = 'public' OR (visibility = 'private' AND (auth.uid() = user_id OR EXISTS (SELECT 1 FROM pack_members WHERE pack_id = feed_events.pack_id AND user_id = auth.uid() AND role = 'admin'))) OR (visibility = 'pack' AND EXISTS (SELECT 1 FROM pack_members WHERE pack_id = feed_events.pack_id AND user_id = auth.uid() AND is_active = true)));

-- PHONE_JAILS
CREATE POLICY "Users can read own phone jails" ON phone_jails FOR SELECT
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM pack_members WHERE pack_id = phone_jails.pack_id AND user_id = auth.uid() AND role = 'admin'));

-- PUNISHMENTS
CREATE POLICY "Pack admins can read punishments" ON punishments FOR SELECT
  USING (EXISTS (SELECT 1 FROM pack_members WHERE pack_id = punishments.pack_id AND user_id = auth.uid() AND role = 'admin'));

-- REACTIONS
CREATE POLICY "Pack members can read reactions" ON reactions FOR SELECT
  USING (EXISTS (SELECT 1 FROM pack_members pm LEFT JOIN feed_events fe ON pm.pack_id = fe.pack_id LEFT JOIN check_ins ci ON pm.pack_id = ci.pack_id WHERE pm.user_id = auth.uid() AND (reactions.feed_event_id = fe.id OR reactions.check_in_id = ci.id)));

CREATE POLICY "Users can create reactions" ON reactions FOR INSERT WITH CHECK (auth.uid() = user_id);

-- COMMENTS
CREATE POLICY "Pack members can read comments" ON comments FOR SELECT
  USING (EXISTS (SELECT 1 FROM pack_members pm LEFT JOIN feed_events fe ON pm.pack_id = fe.pack_id LEFT JOIN check_ins ci ON pm.pack_id = ci.pack_id WHERE pm.user_id = auth.uid() AND (comments.feed_event_id = fe.id OR comments.check_in_id = ci.id)));

CREATE POLICY "Users can create comments" ON comments FOR INSERT WITH CHECK (auth.uid() = user_id);

-- USER_POWERUPS
CREATE POLICY "Users can read own powerups" ON user_powerups FOR SELECT USING (auth.uid() = user_id);

-- CHALLENGE_ROOMS
CREATE POLICY "Users can read all challenges" ON challenge_rooms FOR SELECT USING (true);
CREATE POLICY "Creators can update challenges" ON challenge_rooms FOR UPDATE USING (auth.uid() = creator_id);

-- CHALLENGE_PARTICIPANTS
CREATE POLICY "Users can read challenge participation" ON challenge_participants FOR SELECT USING (auth.uid() = user_id OR true);
CREATE POLICY "Users can participate in challenges" ON challenge_participants FOR INSERT WITH CHECK (auth.uid() = user_id);

-- REPUTATION_LOG
CREATE POLICY "Users can read own reputation history" ON reputation_log FOR SELECT USING (auth.uid() = voter_id);

-- POWERUPS
CREATE POLICY "Everyone can read powerups" ON powerups FOR SELECT USING (true);
