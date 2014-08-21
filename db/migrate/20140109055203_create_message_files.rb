class CreateMessageFiles < ActiveRecord::Migration
  def change
    create_table :message_files do |t|
      t.references :user_file
      t.references :message

      t.timestamps
    end
    add_index :message_files, :user_file_id
    add_index :message_files, :message_id
  end
end
