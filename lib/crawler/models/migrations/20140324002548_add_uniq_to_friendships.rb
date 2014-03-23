class AddUniqToFriendships < ActiveRecord::Migration
  def self.up
    execute <<-SQL
    ALTER TABLE friendships
      ADD CONSTRAINT friendships_friend_id_user_profile_id_key
      UNIQUE (friend_id, user_profile_id);
    SQL
  end

  def self.down
    execute <<-SQL
    ALTER TABLE friendships DROP CONSTRAINT friendships_friend_id_user_profile_id_key;
    SQL
  end
end
