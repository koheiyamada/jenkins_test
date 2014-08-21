class BsUserUpdateForm
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming
  include Loggable
  include UserFormMethods
  include UserFormHowToFindMethods

  validate :ensure_questions_are_answered
  attr_reader :user

  def initialize(bs_user)
    @bs_user = bs_user
    load_answers
  end

  def user
    @bs_user
  end

  attr_reader :how_to_find

  private

  def parse_user(params)
    user.attributes = params[user.class.name.underscore.to_sym]
    parse_address(params)
    parse_user_operating_system(params)
  end

  def load_answers
    @how_to_find = load_how_to_find_answer(user)
  end

  def parse_answers(params)
    @how_to_find = parse_how_to_find_params(params)
  end

  def save_answers
    # この時点でバリデーションは済んでいて、アカウントデータも作成済み
    user.answers.destroy_all
    save_how_to_find_answer
  end

  def ensure_questions_are_answered
    unless user.is_a? Coach
      unless how_to_find_answer_valid?
        how_to_find_answer_errors.full_messages.each do |msg|
          errors.add :how_to_find_form, msg
        end
      end
    end
  end
end