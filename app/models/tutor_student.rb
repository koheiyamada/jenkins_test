class TutorStudent < ActiveRecord::Base
  belongs_to :tutor
  belongs_to :student
  attr_accessible :lesson_report

  after_create do
    logger.event_log('TUTOR', 'STUDENT_ADDED', attributes)
  end

  after_destroy do
    logger.event_log('TUTOR', 'STUDENT_REMOVED', attributes)
  end
end
