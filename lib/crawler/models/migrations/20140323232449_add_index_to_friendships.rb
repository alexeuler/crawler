class AddIndexToFriendships < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      CREATE UNIQUE INDEX friendships_user_profile_id_friend_id_idx
      ON friendships
      USING btree
      (user_profile_id, friend_id);
    SQL
  end

  def self.down
    execute <<-SQL
      DROP INDEX friendships_user_profile_id_friend_id_idx;
    SQL
  end
end
