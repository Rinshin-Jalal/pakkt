-- Migration 010: Triggers
-- Automated workflows for timestamps, calculations, and event logging

CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_timestamp BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_timestamp();
CREATE TRIGGER update_packs_timestamp BEFORE UPDATE ON packs FOR EACH ROW EXECUTE FUNCTION update_timestamp();
CREATE TRIGGER update_pack_members_timestamp BEFORE UPDATE ON pack_members FOR EACH ROW EXECUTE FUNCTION update_timestamp();
CREATE TRIGGER update_goals_timestamp BEFORE UPDATE ON goals FOR EACH ROW EXECUTE FUNCTION update_timestamp();
CREATE TRIGGER update_check_ins_timestamp BEFORE UPDATE ON check_ins FOR EACH ROW EXECUTE FUNCTION update_timestamp();
CREATE TRIGGER update_fines_timestamp BEFORE UPDATE ON fines FOR EACH ROW EXECUTE FUNCTION update_timestamp();
CREATE TRIGGER update_punishments_timestamp BEFORE UPDATE ON punishments FOR EACH ROW EXECUTE FUNCTION update_timestamp();
CREATE TRIGGER update_comments_timestamp BEFORE UPDATE ON comments FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE OR REPLACE FUNCTION on_check_in_success()
RETURNS TRIGGER AS $$
DECLARE
  v_xp_award integer := 10;
  v_streak integer;
  v_is_cheating boolean;
BEGIN
  IF NEW.status = 'success' AND OLD.status IS DISTINCT FROM 'success' THEN
    v_is_cheating := detect_cheating(NEW.user_id, NEW.goal_id);
    
    IF v_is_cheating THEN
      UPDATE check_ins SET status = 'missed' WHERE id = NEW.id;
      RETURN NEW;
    END IF;
    
    v_streak := calculate_streak(NEW.user_id, NEW.pack_id);
    
    IF v_streak > 1 THEN
      v_xp_award := v_xp_award + 5;
    END IF;
    
    UPDATE users SET xp = xp + v_xp_award, updated_at = NOW() WHERE id = NEW.user_id;
    UPDATE packs SET xp = xp + v_xp_award, updated_at = NOW() WHERE id = NEW.pack_id;
    
    NEW.xp_awarded := v_xp_award;
    NEW.verified_at := NOW();
    
    INSERT INTO feed_events (pack_id, user_id, event_type, metadata, visibility, created_at)
    VALUES (
      NEW.pack_id,
      NEW.user_id,
      'checkin_success',
      jsonb_build_object('check_in_id', NEW.id, 'xp_awarded', v_xp_award, 'streak', v_streak),
      'pack',
      NOW()
    );
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_check_in_success_trigger BEFORE UPDATE ON check_ins FOR EACH ROW EXECUTE FUNCTION on_check_in_success();

CREATE OR REPLACE FUNCTION on_user_xp_change()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.xp IS DISTINCT FROM OLD.xp THEN
    NEW.level := calculate_user_level(NEW.xp);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_user_xp_change_trigger BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION on_user_xp_change();

CREATE OR REPLACE FUNCTION on_pack_xp_change()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.xp IS DISTINCT FROM OLD.xp THEN
    NEW.level := calculate_pack_level(NEW.xp);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_pack_xp_change_trigger BEFORE UPDATE ON packs FOR EACH ROW EXECUTE FUNCTION on_pack_xp_change();

CREATE OR REPLACE FUNCTION on_fine_enforced()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'enforced' AND OLD.status IS DISTINCT FROM 'enforced' THEN
    INSERT INTO feed_events (pack_id, user_id, event_type, metadata, visibility, created_at)
    VALUES (
      NEW.pack_id,
      NEW.user_id,
      'fine_voted',
      jsonb_build_object('fine_id', NEW.id, 'amount', NEW.amount),
      'pack',
      NOW()
    );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_fine_enforced_trigger AFTER UPDATE ON fines FOR EACH ROW EXECUTE FUNCTION on_fine_enforced();

CREATE OR REPLACE FUNCTION on_user_level_up()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.level > OLD.level THEN
    INSERT INTO feed_events (pack_id, user_id, event_type, metadata, visibility, created_at)
    SELECT
      pm.pack_id,
      NEW.id,
      'level_up',
      jsonb_build_object('old_level', OLD.level, 'new_level', NEW.level, 'xp', NEW.xp),
      'pack',
      NOW()
    FROM pack_members pm
    WHERE pm.user_id = NEW.id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_user_level_up_trigger AFTER UPDATE ON users FOR EACH ROW EXECUTE FUNCTION on_user_level_up();

CREATE OR REPLACE FUNCTION on_fine_created()
RETURNS TRIGGER AS $$
DECLARE
  v_member pack_members%ROWTYPE;
BEGIN
  FOR v_member IN
    SELECT * FROM pack_members WHERE pack_id = NEW.pack_id AND user_id != NEW.user_id
  LOOP
    INSERT INTO notifications (user_id, type, message, related_entity_id, created_at)
    VALUES (
      v_member.user_id,
      'vote_request',
      'New fine to vote on',
      NEW.id,
      NOW()
    );
  END LOOP;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_fine_created_trigger AFTER INSERT ON fines FOR EACH ROW EXECUTE FUNCTION on_fine_created(); 
