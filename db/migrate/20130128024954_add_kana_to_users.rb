class AddKanaToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name_kana, :string
    add_column :users, :last_name_kana, :string
  end
end
