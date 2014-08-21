class QuestionAnswering
  def initialize(user)
    @user = user
  end

  attr_reader :user

  def answer(answer_option, text=nil)
    answer = user.answers.create(answer_option: answer_option)
    if answer.persisted?
      if text.present?
        answer.create_custom_answer(value: text)
      end
    end
    answer
  end
end