class CreateContactListItems < ActiveRecord::Migration
  def change
    create_table :contact_list_items do |t|
      t.references :user
      t.integer :contactable_id
      t.string  :contactable_type

      t.timestamps
    end
    add_index :contact_list_items, :user_id
    add_index :contact_list_items, :contactable_id
    add_index :contact_list_items, :contactable_type
  end
end
