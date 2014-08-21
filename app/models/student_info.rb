class StudentInfo < ActiveRecord::Base
  belongs_to :student
  belongs_to :grade
  belongs_to :learning_grade, class_name: Grade.name
  attr_accessible :grade_id, :use_textbooks, :teach_by_using_textbooks,
                  :academic_results, :lesson_reports_public, :note,
                  :school

  validates_presence_of :grade_id

  # 受講者の学年に応じたチューターの時給の上乗せ分
  def grade_premium
    if learning_grade
      learning_grade.premium
    elsif grade.present?
      grade.premium
    else
      logger.error "No grade set for student #{student.id}"
      0
    end
  end

  def on_student_updated(student)
    self.referenced_by_hq_user ||= student.reference_id.present? && student.reference.is_a?(HqUser)
    save
    self
  end
end
