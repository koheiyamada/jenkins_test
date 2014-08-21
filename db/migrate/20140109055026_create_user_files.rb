class CreateUserFiles < ActiveRecord::Migration
  def change
    create_table :user_files do |t|
      t.references :user
      t.string :file

      t.timestamps
    end
    add_index :user_files, :user_id
  end
end
