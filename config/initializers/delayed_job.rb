class Delayed::Job < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true
  attr_accessible :owner, :owner_type, :owner_id

  after_create do
    logger.job_log("CREATED", log_attributes)
  end

  after_destroy do
    logger.job_log("DELETED", log_attributes)
  end

  private

    def log_attributes
      {id:id, run_at:run_at, owner_id:owner_id, owner_type:owner_type}
    end
end

Delayed::Worker.class_eval do
  def handle_failed_job_with_notification(job, error)
    handle_failed_job_without_notification(job, error)
    Rails.logger.error "class:#{error.class}\tmessage:#{error.message}\tbacktrace:#{error.backtrace.join(', ')}"
    # only actually send mail in production
    begin
      SystemAdminMailer.background_job_error(job.handler, error).deliver
    rescue Exception => e
      Rails.logger.error "SystemAdminMailer failed: #{e.class.name}: #{e.message}"
      e.backtrace.each do |f|
        Rails.logger.error "  #{f}"
      end
      Rails.logger.flush
    end
  end

  alias_method_chain :handle_failed_job, :notification
end

Delayed::Worker.destroy_failed_jobs = false
#Delayed::Worker.sleep_delay = 60
Delayed::Worker.max_attempts = 5
#Delayed::Worker.max_run_time = 5.minutes
#Delayed::Worker.read_ahead = 10
#Delayed::Worker.delay_jobs = !Rails.env.test?
