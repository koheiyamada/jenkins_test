class AddReferenceIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reference_id, :integer
    add_index :users, :reference_id
  end
end
