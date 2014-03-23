class AddVkIdIndexToUserProfiles < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      CREATE UNIQUE INDEX user_profiles_vk_id_idx
        ON user_profiles
        USING btree
        (vk_id);
    SQL
  end

  def self.down
    execute <<-SQL
      DROP INDEX user_profiles_vk_id_idx;
    SQL
  end
end
