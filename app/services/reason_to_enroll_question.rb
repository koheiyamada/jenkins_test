class ReasonToEnrollQuestion
  class << self
    def answers_to_hash(answers)
      answer_options = question.answer_options.each_with_object({}) do |option, obj|
        obj[option.code] = {selected: '0'}
      end
      answers.each do |answer|
        code = answer.answer_option_code
        answer_options[code][:selected] = '1'
        if answer.custom_answer.present?
          answer_options[code][:text] = answer.custom_answer.value
        end
      end
      {answer_options: answer_options}
    end

    def question
      Question.find_by_code :reason_to_enroll
    end
  end
end