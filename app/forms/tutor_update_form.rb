class TutorUpdateForm
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming
  include Loggable
  include UserFormMethods
  include UserFormHowToFindMethods

  validate :ensure_questions_are_answered

  def initialize(tutor)
    @tutor = tutor
    load_answers
  end

  attr_reader :tutor, :how_to_find

  def update(params)
    parse_user(params)
    parse_answers(params)
    save
  end

  def user
    @tutor
  end

  private

    def save
      if valid?
        save_all
      else
        logger.debug errors.full_messages
        false
      end
    end

    def parse_user(params)
      tutor.attributes = params[:tutor]
      tutor.info.attributes = params[:tutor_info]
      parse_address2(params, :current_address)
      parse_address2(params, :hometown_address)
      parse_price(params)
      parse_user_operating_system(params)
    end

    def parse_price(params)
      if params[:tutor_price]
        tutor.price.attributes = params[:tutor_price]
      end
    end

    def load_answers
      @how_to_find = load_how_to_find_answer(user)
    end

    def parse_answers(params)
      @how_to_find = parse_how_to_find_params(params)
    end

    def save_answers
      # この時点でバリデーションは済んでいて、アカウントデータも作成済み
      tutor.answers.destroy_all
      save_how_to_find_answer
    end

    def save_all
      User.transaction do
        user.save!
        save_answers
        true
      end
    rescue => e
      logger.error e
      false
    end

    def ensure_questions_are_answered
      unless how_to_find_answer_valid?
        how_to_find_answer_errors.full_messages.each do |msg|
          errors.add :how_to_find_form, msg
        end
      end
    end
end