class HowToFindQuestion
  class << self
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
end