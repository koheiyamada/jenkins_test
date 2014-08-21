class BasicLessonExtension < ScheduledJob

  def self.perform
    today = Date.today
    year  = today.year
    month = today.month
    BasicLessonInfo.extend!(year, month)
  end

end