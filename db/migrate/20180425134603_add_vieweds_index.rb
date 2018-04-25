class AddViewedsIndex < ActiveRecord::Migration[5.1]
  def change
    add_index :vieweds, :post_id
    add_index :vieweds, :user_id
    add_index :vieweds, [:post_id, :user_id]
  end
end
