class MonitorInactiveTutors < ScheduledJob
  def self.perform
    Tutor.monitor_inactive_tutors
  end
end
