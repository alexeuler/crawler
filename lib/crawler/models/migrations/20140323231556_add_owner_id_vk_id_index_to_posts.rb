class AddOwnerIdVkIdIndexToPosts < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      CREATE UNIQUE INDEX posts_owner_id_vk_id_idx
      ON posts
      USING btree
      (owner_id, vk_id);
    SQL
  end

  def self.down
    execute <<-SQL
      DROP INDEX posts_owner_id_vk_id_idx;
    SQL
  end
end
