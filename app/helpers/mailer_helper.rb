module MailerHelper
  def mailer_hostname
    `hostname`.strip
  rescue => e
    Rails.logger.error e
    '?'
  end
end