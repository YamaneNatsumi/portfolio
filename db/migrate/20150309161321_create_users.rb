class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user
      t.text :comment
      t.string :password
      t.string :image, null: true 
      t.timestamps
    end
  end
end
