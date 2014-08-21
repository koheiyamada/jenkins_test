class CreateCustomAnswers < ActiveRecord::Migration
  def change
    create_table :custom_answers do |t|
      t.references :answer
      t.string :value

      t.timestamps
    end
    add_index :custom_answers, :answer_id
  end
end
