class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.references :user
      t.references :answer_option

      t.timestamps
    end
    add_index :answers, :user_id
    add_index :answers, :answer_option_id
  end
end
