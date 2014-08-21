class AddAnswerOptionCodeToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :answer_option_code, :string, :null => false

    Answer.all.each do |answer|
      answer.update_attribute(:answer_option_code, answer.answer_option.code)
    end
  end
end
