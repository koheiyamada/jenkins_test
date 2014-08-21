module AnswersHelper
  def answer_display_name(answer)
    if answer.custom_answer.present?
      t("answer_option.#{answer.answer_option_code}") + ':' + answer.custom_answer.value
    else
      t("answer_option.#{answer.answer_option_code}")
    end
  end
  def answer_display_name_with_num(answer)
    t("answer_option.#{answer.answer_option_code}", :num => SystemSettings.free_lesson_limit_number)
  end
end