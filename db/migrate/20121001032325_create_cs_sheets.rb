class CreateCsSheets < ActiveRecord::Migration
  def change
    create_table :cs_sheets do |t|
      t.references :author
      t.references :lesson
      t.integer :score
      t.text :content

      t.timestamps
    end
    add_index :cs_sheets, :author_id
    add_index :cs_sheets, :lesson_id
  end
end
