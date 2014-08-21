class MonitoringMailer < ActionMailer::Base
  class << self
    def monitoring_email_addresses
      SystemSettings.monitoring_email_address || []
    end
  end

  layout 'mail'
  helper :users

  def message_created(message)
    @message = message
    emails = MonitoringMailer.monitoring_email_addresses
    if emails.present?
      mail to: emails
    end
  end
end
