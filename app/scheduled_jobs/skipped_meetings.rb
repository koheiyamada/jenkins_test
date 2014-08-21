class SkippedMeetings < ScheduledJob

  def self.perform
    Meeting.handle_skipped_meetings(Date.yesterday)
  end

end