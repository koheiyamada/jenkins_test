# coding: utf-8

class StudentUpdateForm
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming
  include Loggable

  # 各アンケートの回答を保持する
  attr_reader :how_to_find      # {"answer_option" => "hoge", 'hoge_value' => 'fuga'}
  attr_reader :reason_to_enroll # {"answer_options" => {"option1" => {'selected' => '0' or '1', 'text' => 'hoge'}, ...}}

  attr_reader :student

  validate :ensure_student_is_valid
  validate :ensure_questions_are_answered

  def initialize(student)
    @student = student
    # 質問
    answer = student.answers.to_question(:how_to_find).first
    @how_to_find = HowToFindQuestion.answer_to_hash(answer)
    answers = student.answers.to_question(:reason_to_enroll)
    @reason_to_enroll = ReasonToEnrollQuestion.answers_to_hash(answers)
  end


  def persisted?
    false
  end

  def save
    if valid?
      save_all
    else
      logger.debug errors.full_messages
      false
    end
  end

  def update(params)
    # 本体の更新
    @student.attributes = params[:student]
    # 住所の更新
    if @student.address
      @student.address.attributes = (params[:address])
    else
      @student.build_address(params[:address])
    end
    # 受講者固有情報の更新
    @student.student_info.attributes = params[:student_info]
    # 支払方法の更新
    if params[:payment_method].present?
      @student.payment_method = PaymentMethod.new(params[:payment_method])
    end
    # アンケートの更新
    @how_to_find = params[:how_to_find]
    @reason_to_enroll = params[:reason_to_enroll]
    # 使用OSの更新
    if params[:user_operating_system].present?
      @student.build_user_operating_system(params[:user_operating_system])
    end
    ##無料体験レッスン受講回数の更新
    if params[:free_lesson_taken].present?
      @student.free_lesson_taken = params[:free_lesson_taken]
    end
    # 保存の実行
    save
  end

  def create_questionnaire_answers
    # この時点でバリデーションは済んでいて、アカウントデータも作成済み
    logger.debug '-------------------------------- DELETE'
    student.answers.destroy_all # すでにセットされているものがあれば削除する
    logger.debug '-------------------------------- DELETE 2'
    answer = create_answer_to_how_to_find_question
    if answer.nil? || answer.errors.any?
      logger.error "Failed to create questionnaire answer for 'how to find' question."
    end
    answers = create_answer_reason_to_enroll_question
  end

  def create_answer_to_how_to_find_question
    question = Question.find_by_code('how_to_find')
    qa = QuestionAnswering.new(student)
    answer_option_code = how_to_find[:answer_option]
    answer_option = question.answer_options.find_by_code(answer_option_code)
    if answer_option.present?
      text_key = answer_option_code + '_value'
      text = how_to_find[text_key]
      qa.answer(answer_option, text)
    else
      nil
    end
  end

  def create_answer_reason_to_enroll_question
    answers = []
    question = Question.find_by_code('reason_to_enroll')
    qa = QuestionAnswering.new(student)
    answer_options = reason_to_enroll[:answer_options]
    answer_options.each do |answer_option_code, answer_option_fields|
      if answer_option_fields[:selected] == '1'
        text = answer_option_fields[:text]
        answer_option = question.answer_options.find_by_code(answer_option_code)
        answer = qa.answer(answer_option, text)
        if answer.errors.empty?
          answers << answer
        else
          logger.error "Failed to create answer_to 'reason_to_enroll'. code: #{answer_option_code}"
        end
      end
    end
    answers
  end

  private

    def ensure_student_is_valid
      if student.invalid?
        student.errors.full_messages.each do |msg|
          errors.add :student, msg
        end
      end
    end

    def save_all
      Student.transaction do
        @student.save!
        if @student.independent?
          create_questionnaire_answers
        end
        true
      end
    rescue => e
      logger.error e
      false
    end

    def ensure_questions_are_answered
      logger.debug '---------- validate_questions_are_answered'
      validate_how_to_find_question_is_answered
      validate_reason_to_enroll_question_is_answered
    end

    def validate_how_to_find_question_is_answered
      if student.independent?
        if how_to_find.nil? || how_to_find[:answer_option].blank?
          errors.add :how_to_find, I18n.t('student_entry_form.how_to_find_question.not_answered')
        else
          code = how_to_find[:answer_option]
          if AnswerOption.where(code: code).empty?
            errors.add :how_to_find, :invalid_answer_option
          end
        end
      end
    end

    def validate_reason_to_enroll_question_is_answered
      if student.independent?
        if reason_to_enroll.nil? || reason_to_enroll[:answer_options].blank?
          errors.add :reason_to_enroll, :not_answered
        else
          answer_options = reason_to_enroll[:answer_options]
          if answer_options.all?{|code, option| option[:selected] == '0'}
            errors.add :reason_to_enroll, I18n.t('student_entry_form.reason_to_enroll_question.not_answered')
          end
        end
      end
    end
end