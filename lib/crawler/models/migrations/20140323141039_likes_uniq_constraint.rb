class LikesUniqConstraint < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      ALTER TABLE likes
        ADD CONSTRAINT post_user_uniq UNIQUE (post_id, user_profile_id);
    SQL
  end

  def self.down
    execute <<-SQL
      ALTER TABLE likes
        DROP CONSTRAINT post_user_uniq;
    SQL
  end


end
