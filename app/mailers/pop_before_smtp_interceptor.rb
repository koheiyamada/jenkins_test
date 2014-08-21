require 'net/pop'

class PopBeforeSmtpInterceptor
  def initialize(smtp_settings)
    @smtp_settings = smtp_settings
  end

  def delivering_email(message)
    Net::POP3.auth_only(@smtp_settings[:address], 110, @smtp_settings[:user_name], @smtp_settings[:password])
  end
end