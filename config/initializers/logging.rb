Grizzled::Rails::Logger.configure do |cfg|
  # Configuration data goes here
  #cfg.format = "%Y-%m-%d %H:%M:%S"
  cfg.timeformat = '%Y/%m/%d %H:%M:%S.%L'
end

define_custom_logging_methods = lambda do
  public

  def event_log(type, event, args={})
    msg = args.map{|k, v| "#{k}:#{v}"}.join("\t")
    info("[EVENT #{type}:#{event}] #{msg}")
  end

  def account_log(event, args={})
    event_log('ACCOUNT', event, args)
  end

  def lesson_log(event, args={})
    event_log('LESSON', event, args)
  end

  def charge_log(event, args={})
    event_log('CHARGE', event, args)
  end

  def message_log(event, args={})
    event_log('MESSAGE', event, args)
  end

  def upgrade_log(event, args={})
    event_log('UPGRADE', event, args)
  end

  def job_log(event, args={})
    event_log('JOB', event, args)
  end

  def journal_log(event, args={})
    event_log 'JOURNAL', event, args
  end
end

Logger.instance_eval do
  define_custom_logging_methods.call
end

Rails.logger.class_eval do
  define_custom_logging_methods.call
end
