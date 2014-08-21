class TeachingSubject < ActiveRecord::Base
  belongs_to :tutor
  belongs_to :subject
  belongs_to :grade_group
  belongs_to :subject_level
  attr_accessible :level, :tutor, :subject, :grade_group, :subject_level

  validates_presence_of :subject_level_id, :subject_id, :tutor_id, :grade_group_id, :level

  before_validation do
    self.level = subject_level.level
    self.grade_group_id = subject_level.subject.grade_group_id
    self.subject_id = subject_level.subject_id
  end

  def grade_group_name
    grade_group && grade_group.name
  end

  def subject_name
    subject && subject.name
  end

  def level_name
    subject_level.code
  end
end
