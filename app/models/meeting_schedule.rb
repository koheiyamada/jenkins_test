class MeetingSchedule < ActiveRecord::Base
  belongs_to :meeting
  has_many :meeting_members, foreign_key: :preferred_schedule_id
  attr_accessible :datetime

  validates_presence_of :datetime
  validate :future_datetime, :if => 'datetime.present?'

  private

    def future_datetime
      if datetime < Time.current
        errors.add :datetime, :not_future
      end
    end
end
