class CreateAnswerOptions < ActiveRecord::Migration
  def change
    create_table :answer_options, :force => true do |t|
      t.references :question
      t.string :code

      t.timestamps
    end
    add_index :answer_options, :question_id
  end
end
