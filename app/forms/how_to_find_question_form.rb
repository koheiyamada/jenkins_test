class HowToFindQuestionForm
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming
  include Loggable

  class << self
    def find_for_user(user)
      answer = user.answer_to_how_to_find
      how_to_find = answer_to_hash(answer)
      if how_to_find
        HowToFindQuestionForm.new(user, how_to_find)
      end
    end

    def answer_to_hash(answer)
      return nil if answer.nil?
      code = answer.answer_option_code
      h = {answer_option: code}
      if answer.custom_answer.present?
        h[:"#{code}_value"] = answer.custom_answer.value
      end
      h
    end
  end

  validate :ensure_question_is_answered
  QUESTION_CODE = 'how_to_find'

  def initialize(user, params={})
    params ||= {}
    @user = user
    @attributes = params
    @code = params[:answer_option]
    @text = params["#{@code}_value"]
  end

  attr_reader :user, :attributes
  attr_reader :code, :text

  def question
    @question ||= Question.find_by_code(QUESTION_CODE)
  end

  def answer
    @answer ||= user.answers.to_question(QUESTION_CODE).first
  end

  def save
    answer_option = question.answer_options.find_by_code(code)
    if answer_option.present?
      answer = create_answer_of_user(user, answer_option, text)
      answer.persisted?
    else
      false
    end
  end

  def create_answer
    question_answering = QuestionAnswering.new(user)
    answer_option = question.answer_options.find_by_code(code)
    if answer_option.present?
      @answer = question_answering.answer(answer_option, text)
    else
      nil
    end
  end

  def ensure_question_is_answered
    if code.nil?
      errors.add :code, :not_present
    else
      if AnswerOption.where(code: code).empty?
        errors.add :code, :invalid
      end
    end
  end

  def create_answer_of_user(user, answer_option, text=nil)
    answer = user.answers.create(answer_option: answer_option)
    if answer.persisted?
      if text.present?
        answer.create_custom_answer(value: text)
      end
    end
    answer
  end
end