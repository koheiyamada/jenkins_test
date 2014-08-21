class ActionMailer::Base
  default from: 'AIDnet <noreply@aidnet.jp>'

  if delivery_method == :smtp
    register_interceptor PopBeforeSmtpInterceptor.new(smtp_settings)
  end
end
