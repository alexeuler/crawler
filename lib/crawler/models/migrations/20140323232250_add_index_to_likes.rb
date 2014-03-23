class AddIndexToLikes < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      CREATE UNIQUE INDEX likes_post_id_idx
      ON likes
      USING btree
      (post_id);
      CREATE UNIQUE INDEX likes_user_profile_id_idx
      ON likes
      USING btree
      (user_profile_id);
    SQL
  end

  def self.down
    execute <<-SQL
      DROP INDEX likes_post_id_idx;
      DROP INDEX likes_user_profile_id_idx;
    SQL
  end

end
