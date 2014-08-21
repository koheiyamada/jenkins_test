module QuestionnaireResponder
  def self.included(base)
    base.has_many :answers, :as => :owner, :dependent => :destroy
  end

  def answer_to_how_to_find
    @answer_to_how_to_find ||= answers.to_question(:how_to_find).first
  end
end