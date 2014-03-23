class AddFkeysToFriendships < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      ALTER TABLE friendships
        ADD CONSTRAINT friend_id_fkey FOREIGN KEY (friend_id)
        REFERENCES user_profiles (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE CASCADE;

      ALTER TABLE friendships
        ADD CONSTRAINT user_profile_id_fkey FOREIGN KEY (user_profile_id)
        REFERENCES user_profiles (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE CASCADE;

    SQL
  end

  def self.down
    execute <<-SQL
      ALTER TABLE friendships DROP CONSTRAINT friend_id_fkey;
      ALTER TABLE friendships DROP CONSTRAINT user_profile_id_fkey;
    SQL

  end
end
