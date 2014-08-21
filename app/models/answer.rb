class Answer < ActiveRecord::Base
  class << self
    def to_question(code)
      includes(:answer_option => :question).where(questions: {code: code})
    end
  end

  belongs_to :user
  belongs_to :owner, :polymorphic => true
  belongs_to :answer_option
  has_one :custom_answer, :dependent => :delete

  attr_accessible :answer_option, :owner

  validates_presence_of :answer_option_id, :owner

  before_save :make_cache
  before_save :set_owner_if_empty

  def init
    make_cache
    self
  end

  private

    def make_cache
      if answer_option.present?
        self.answer_option_code = answer_option.code
      end
    end

    def set_owner_if_empty
      if user.present?
        if owner.blank?
          self.owner = user
        end
      end
    end
end
