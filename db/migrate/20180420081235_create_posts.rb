class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.integer  :user_id
      t.string   :title, null: false
      t.text     :content, null: false
      t.string   :image

      t.string   :authority, default: "all", null: false
      t.string   :status, default: "public", null: false

      t.integer  :comments_count, default: 0, null: false
      t.integer  :viewed_count, default: 0, null: false
      t.integer  :upvotes_count, default: 0, null: false

      t.timestamps
    end
  end
end
