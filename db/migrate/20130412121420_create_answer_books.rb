class CreateAnswerBooks < ActiveRecord::Migration
  def change
    create_table :answer_books do |t|
      t.references :textbook
      t.string :dir
      t.integer :width
      t.integer :height

      t.timestamps
    end
    add_index :answer_books, :textbook_id
  end
end
