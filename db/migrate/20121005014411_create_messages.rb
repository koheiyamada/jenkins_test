class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :sender
      t.references :student
      t.string :title
      t.text :text

      t.timestamps
    end
    add_index :messages, :sender_id
    add_index :messages, :student_id
  end
end
