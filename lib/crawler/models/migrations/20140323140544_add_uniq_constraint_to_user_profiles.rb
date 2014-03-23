class AddUniqConstraintToUserProfiles < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      ALTER TABLE user_profiles
        ADD CONSTRAINT vk_id_uniq UNIQUE (vk_id);
    SQL
  end

  def self.down
    execute <<-SQL
      ALTER TABLE user_profiles
        DROP CONSTRAINT vk_id_uniq;
    SQL
  end

end
