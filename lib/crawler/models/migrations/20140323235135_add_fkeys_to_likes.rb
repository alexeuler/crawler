class AddFkeysToLikes < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      ALTER TABLE likes
        ADD CONSTRAINT post_id_fkey FOREIGN KEY (post_id)
        REFERENCES posts (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE CASCADE;

      ALTER TABLE likes
        ADD CONSTRAINT user_profile_id_fkey FOREIGN KEY (user_profile_id)
        REFERENCES user_profiles (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE CASCADE;
    SQL
  end

  def self.down
    execute <<-SQL
      ALTER TABLE likes DROP CONSTRAINT post_id_fkey;
      ALTER TABLE likes DROP CONSTRAINT user_profile_id_fkey;
    SQL

  end
end
