class TutorDailyLessonSkip < ActiveRecord::Base
  class << self
    def total_count
      sum(:count)
    end
  end

  belongs_to :tutor
  attr_accessible :count, :date

  validates_presence_of :tutor_id
  validates_uniqueness_of :date, :scope => :tutor_id
end
