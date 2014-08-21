# -*- encoding: utf-8 -*- #

class SystemAdminMailer < ActionMailer::Base
  default from: 'info@aidnet.jp'
  helper :mailer

  def error_happened(request, status, error, current_user=nil)
    emails = SystemSettings.email_for_error_nortification
    if emails.present?
      @request = request
      @status = status
      @error = error
      @current_user = current_user
      mail to: emails
    end
  end

  def scheduled_job_error_happened(job_name, error)
    background_job_error(job_name, error)
  end

  def background_job_error(job_name, error)
    emails = SystemSettings.email_for_error_nortification
    if emails.present?
      @job_name = job_name
      @error = error
      mail to: emails
    end
  end

  def error_on_charging(name, error)
    emails = SystemSettings.email_for_error_nortification
    if emails.present?
      @name = name
      @error = error
      mail to: emails
    end
  end

  def minor_student_overlap_registing(student)
    emails = SystemSettings.email_for_error_nortification
    if emails.present?
      @student = student
      mail to: emails, subject: "受講者不正登録通知"
    end
  end
end
