class LessonRequestRejection < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :user
  attr_accessible :reason

  validates_presence_of :reason

  before_validation :set_default_user

  after_create :reject_lesson_request

  private

    def set_default_user
      if user.blank? && lesson.present?
        self.user = lesson.tutor
      end
    end

    def reject_lesson_request
      logger.debug "Rejecting lesson request #{lesson.id}"
      lesson.reject
      logger.debug "Rejected lesson request #{lesson.id}"
    end
end
