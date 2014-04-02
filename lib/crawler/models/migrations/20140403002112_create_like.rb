class CreateLike < ActiveRecord::Migration
  def change
    create_table "likes", force: true do |t|
      t.integer "user_profile_id"
      t.integer "post_id"
    end
  end
end
