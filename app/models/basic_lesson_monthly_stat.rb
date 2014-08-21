class BasicLessonMonthlyStat < ActiveRecord::Base
  belongs_to :basic_lesson_info
  attr_accessible :tutor_schedule_change_count

  #validates_presence_of :year, :month
  #validates_numericality_of :year, :only_integer => true
  #validates_numericality_of :month, :only_integer => true
  #validates_uniqueness_of :month, :scope => [:user_id, :month]
end
