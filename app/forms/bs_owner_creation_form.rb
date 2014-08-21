class BsOwnerCreationForm
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming
  include Loggable

  # 各アンケートの回答を保持する
  attr_reader :how_to_find      # {"answer_option" => "hoge", 'hoge_value' => 'fuga'}
  attr_reader :how_to_find_form
  attr_reader :bs_user, :bs

  validate :ensure_user_is_valid
  validate :ensure_how_to_find_question_is_answered

  def initialize(bs, params={})
    @bs = bs
    @bs_app_form = bs.app_form
    if params.size > 0
      init_with_hash(params)
    else
      init_answer_with_form(@bs_app_form)
    end
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

  private

  def init_with_hash(params)
    @bs_user = BsUser.new(params[:bs_user]) do |bs_user|
      bs_user.organization = bs
      bs_user.address = Address.new(params[:address]) if params[:address].present?
      if bs.app_form.present?
        bs_user.answers = bs.app_form.answers.map{|a| a.dup}
      end
    end
    @how_to_find = params[:how_to_find]
    @how_to_find_form = HowToFindQuestionForm.new(bs_user, params[:how_to_find])
  end

  def init_answer_with_form(bs_app_form)
    answer = bs_app_form.answers.to_question(:how_to_find).first
    logger.debug "answer = #{answer}"
    @how_to_find = HowToFindQuestion.answer_to_hash(answer)
    logger.debug "how_to_find = #{@how_to_find}"
    @how_to_find_form = HowToFindQuestionForm.new(self)
    logger.debug "how_to_find_form = #{@how_to_find_form}"
  end

  def save_all
    # バリデーションが済んだ後で呼ばれる。
    BsUser.transaction do
      bs_user.save!
      how_to_find_form.save
      bs.set_representative(bs_user)
      true
    end
  rescue => e
    logger.error e
    false
  end

  def ensure_user_is_valid
    if bs_user.invalid?
      bs_user.errors.full_messages.each do |msg|
        errors.add :bs_user, msg
      end
    end
  end

  def ensure_how_to_find_question_is_answered
    if how_to_find_form.invalid?
      how_to_find_form.errors.full_messages.each do |msg|
        errors.add :how_to_find_form, msg
      end
    end
  end
end