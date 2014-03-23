class AddPrimaryFriendshipsUniqConstraint < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      ALTER TABLE friendships
        ADD CONSTRAINT primary_friend_uniq UNIQUE (user_profile_id, friend_id);
    SQL
  end

  def self.down
    execute <<-SQL
      ALTER TABLE friendships
        DROP CONSTRAINT primary_friend_uniq;
    SQL
  end

end
