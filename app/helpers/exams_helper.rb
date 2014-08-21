module ExamsHelper
  def exam_name(exam)
    t("titles.exam_for_grade_subject_month", grade:grade_name(exam.grade), subject:exam.subject.name, month:l(exam.month, :format => :month_year))
  end

  def exam_path(exam)
    {action:"show", subject_id:exam.subject_id, year:exam.month.year, month:exam.month.month}
  end

  def exam_room_path(exam)
    {action:"room", subject_id:exam.subject_id, year:exam.month.year, month:exam.month.month}
  end

  def exam_term(exam)
    if exam.beginning_of_term.present? && exam.end_of_term.present?
      "%{d1} - %{d2}" % {d1:l(exam.beginning_of_term.to_date, :format => :month_day), d2:l(exam.end_of_term.to_date, :format => :month_day)}
    else
      t("common.undefined")
    end
  end
end