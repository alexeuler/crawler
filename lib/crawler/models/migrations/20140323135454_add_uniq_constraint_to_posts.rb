class AddUniqConstraintToPosts < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      ALTER TABLE posts
        ADD CONSTRAINT owner_id_and_vk_id_uniq UNIQUE (owner_id, vk_id);
    SQL
  end

  def self.down
    execute <<-SQL
      ALTER TABLE posts
        DROP CONSTRAINT owner_id_and_vk_id_uniq
    SQL
  end

end
