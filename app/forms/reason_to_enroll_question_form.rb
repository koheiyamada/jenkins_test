class ReasonToEnrollQuestionForm
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming
  include Loggable

  validate :ensure_question_is_answered

  def initialize(user, params={})
    @user = user
    @fields = params[:answer_options]
  end

  attr_reader :user, :fields

  def question
    @question ||= Question.find_by_code('reason_to_enroll')
  end

  def answers
    @answers ||= user.answers.to_question(:reason_to_enroll)
  end

  def create_answers
    @answers = []
    question_answering = QuestionAnswering.new(user)
    fields.each do |answer_option_code, answer_option_fields|
      if answer_option_fields[:selected] == '1'
        text = answer_option_fields[:text]
        answer_option = question.answer_options.find_by_code(answer_option_code)
        answer = question_answering.answer(answer_option, text)
        if answer.errors.empty?
          @answers << answer
        else
          logger.error "Failed to create answer_to 'reason_to_enroll'. code: #{answer_option_code}"
        end
      end
    end
    @answers
  end

  def ensure_question_is_answered
    if fields.blank?
      errors.add :fields, :not_answered
    else
      if fields.all?{|code, option| option[:selected] == '0'}
        errors.add :fields, :not_answered
      end
    end
  end
end