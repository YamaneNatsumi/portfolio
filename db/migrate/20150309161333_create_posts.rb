class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :explain
      t.string :url
      t.string :image
      t.timestamps
    end
  end
end
