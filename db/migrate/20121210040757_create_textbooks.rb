class CreateTextbooks < ActiveRecord::Migration
  def change
    create_table :textbooks do |t|
      t.integer :textbook_id
      t.string :title
      t.integer :pages
      t.string :direction
      t.boolean :double_pages

      t.timestamps
    end
    add_index :textbooks, :textbook_id
  end
end
