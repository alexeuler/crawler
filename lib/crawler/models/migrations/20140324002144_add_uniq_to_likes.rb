class AddUniqToLikes < ActiveRecord::Migration
def self.up
  execute <<-SQL
    ALTER TABLE likes
      ADD CONSTRAINT likes_post_id_user_profile_id_key
      UNIQUE (post_id, user_profile_id);
  SQL
end

 def self.down
   execute <<-SQL
    ALTER TABLE likes DROP CONSTRAINT likes_post_id_user_profile_id_key;
   SQL
end
end
