# coding: utf-8

class ParentEntryForm
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming
  include Loggable

  # 各アンケートの回答を保持する
  attr_reader :how_to_find      # {"answer_option" => "hoge", 'hoge_value' => 'fuga'}
  attr_reader :reason_to_enroll # {"answer_options" => {"option1" => {'selected' => '0' or '1', 'text' => 'hoge'}, ...}}
  attr_reader :how_to_find_form, :reason_to_enroll_form

  validate :ensure_user_is_valid
  validate :ensure_questions_are_answered

  def initialize(params = {})
    if params.is_a? Hash
      init_with_hash params
    elsif params.is_a? Parent
      init_with_user params
    end
  end

  def user
    @user
  end

  def init_with_hash(params)
    if params.size > 0
      @parent_registration_form = params[:parent_registration_form]
      @address = Address.new(params[:address])
      @user = Parent.new(params[:parent]) do |parent|
        parent.password = Parent.generate_password
        parent.address = @address
        #parent.email = @parent_registration_form.email
        if @parent_registration_form
          parent.registration_form = @parent_registration_form
          parent.spec = @parent_registration_form
        end
        set_payment_method(parent, params)
        set_user_operating_system(parent, params)
      end
      @how_to_find = params[:how_to_find]
      @reason_to_enroll = params[:reason_to_enroll]
      @how_to_find_form = HowToFindQuestionForm.new(user, params[:how_to_find])
      @reason_to_enroll_form = ReasonToEnrollQuestionForm.new(user, params[:reason_to_enroll])
      logger.debug '--------------------- アンケート入力 ---------------------'
      logger.debug @how_to_find
      logger.debug @reason_to_enroll
      logger.debug '--------------------------------------------------------'
    end
  end

  def init_with_user(user)
    @user = user
    answer = user.answers.to_question(:how_to_find).first
    @how_to_find = HowToFindQuestion.answer_to_hash(answer)
    @how_to_find_form = HowToFindQuestionForm.new(user)
    answers = user.answers.to_question(:reason_to_enroll)
    @reason_to_enroll = ReasonToEnrollQuestion.answers_to_hash(answers)
    @reason_to_enroll_form = ReasonToEnrollQuestionForm.new(user)
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
    user.attributes = params[:parent]
    if user.address
      user.address.attributes = (params[:address])
    else
      user.build_address(params[:address])
    end
    set_payment_method(user, params)
    set_user_operating_system(user, params)
    @how_to_find = params[:how_to_find]
    @reason_to_enroll = params[:reason_to_enroll]
    @how_to_find_form = HowToFindQuestionForm.new(user, params[:how_to_find])
    @reason_to_enroll_form = ReasonToEnrollQuestionForm.new(user, params[:reason_to_enroll])
    save
  end

  def create_questionnaire_answers
    # この時点でバリデーションは済んでいて、アカウントデータも作成済み
    user.answers.destroy_all # すでにセットされているものがあれば削除する

    answer = how_to_find_form.create_answer
    if answer.nil? || answer.errors.any?
      logger.error "Failed to create questionnaire answer for 'how to find' question."
    end

    answers = reason_to_enroll_form.create_answers
  end

  private

  def ensure_user_is_valid
    if user.invalid?
      user.errors.full_messages.each do |msg|
        errors.add :user, msg
      end
    end
  end

  def save_all
    Parent.transaction do
      if user.save!
        create_questionnaire_answers
      else
        user.errors.full_messages.each do |msg|
          errors.add :user, msg
        end
      end
      self.errors.empty?
    end
  rescue => e
    logger.error e
    false
  end

  def ensure_questions_are_answered
    if how_to_find_form.invalid?
      how_to_find_form.errors.full_messages.each do |msg|
        errors.add :how_to_find_form, msg
      end
    end
    if reason_to_enroll_form.invalid?
      reason_to_enroll_form.errors.full_messages.each do |msg|
        errors.add :reason_to_enroll_form, msg
      end
    end
  end

  private

    def set_user_operating_system(parent, params)
      if params[:user_operating_system].present?
        parent.build_user_operating_system(params[:user_operating_system])
      end
    end

    def set_payment_method(parent, params)
      if params[:payment_method].present?
        parent.payment_method = PaymentMethod.new(params[:payment_method])
      end
    end
end