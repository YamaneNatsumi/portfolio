class AddUserToPosts < ActiveRecord::Migration
  def change
  	# [形式] add_column(テーブル名, カラム名, データ型)
    add_column :posts, :user, :string
  end
end
