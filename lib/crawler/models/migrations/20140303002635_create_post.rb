class CreatePost < ActiveRecord::Migration
  def change
    create_table "posts", force: true do |t|
      t.integer "vk_id", null: false
      t.integer "owner_id", null: false
      t.text "text"
      t.string "attachment_type"
      t.string "attachment_image"
      t.text "attachment_text"
      t.string "attachment_url"
      t.timestamps
      t.integer "attachment_id"
      t.integer "attachment_owner_id"
      t.string "attachment_title"
      t.integer "date"
      t.integer "copy_owner_id"
      t.integer "copy_post_id"
      t.integer "reposts_count", default: 0
      t.integer "comments_count", default: 0
      t.integer "likes_count", default: 0
      t.integer "likes_age"
      t.float "likes_share"
      t.float "closed_profiles_share"
    end
  end
end
