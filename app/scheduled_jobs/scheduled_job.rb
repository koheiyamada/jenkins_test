class ScheduledJob

  def self.execute
    Rails.logger.info "[Scheduled Job] Starting #{name}#execute..."
    perform
    Rails.logger.info "[Scheduled Job] Finished #{name}#execute."
  rescue => e
    Rails.logger.error "[Scheduled Job] Error in #{name}#execute. #{e}"
    SystemAdminMailer.scheduled_job_error_happened(name, e).deliver
  end

  def self.perform
    # template
  end

end