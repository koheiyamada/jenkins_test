class UserMailer < ActionMailer::Base
  layout 'mail'
  helper :users

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.registration_accepted.subject
  #
  def registration_accepted(params)
    if [:to, :confirmation_url].any?{|k| params[k].blank?}
      raise "Invalid arguments"
    end
    @url = params[:confirmation_url]
    logger.debug @url

    mail to: params[:to]
  end

  def parent_registration_form_created(parent_registration_form)
    @parent_registration_form = parent_registration_form
    mail(to: @parent_registration_form.email) do |format|
      format.text { render layout: 'mail_for_nonuser' }
    end
  end

  def student_registration_form_created(student_registration_form)
    @student_registration_form = student_registration_form
    mail(to: student_registration_form.email) do |format|
      format.text { render layout: 'mail_for_nonuser' }
    end
  end

  def message_created(message, recipient)
    @message = message
    @recipient = recipient
    if recipient.respond_to?(:email) && recipient.email.present?
      mail to: recipient.emails
    end
  end

  def optional_lesson_requested(lesson)
  end

  def optional_lesson_accepted(lesson)
  end

  def optional_lesson_rejected(lesson)
  end

  def optional_lesson_ignored(lesson)
  end

  def basic_lesson_info_activated(basic_lesson_info)
  end

  def lesson_coming_notification(lesson)
  end

  def bs_app_form_accepted(bs_app_form)
    @bs_app_form = bs_app_form
    mail to: bs_app_form.email
  end

  def tutor_app_form_accepted(tutor_app_form)
    @tutor_app_form = tutor_app_form
    mail to: tutor_app_form.pc_mail
  end

  def parent_created(parent, password=nil)
    @parent = parent
    @password = password if password.present?
    mail to: parent.emails
  end

  def student_created(student, password=nil)
    @student = student
    @password = password if password.present?
    mail to: student.emails
  end

  def coach_created(coach, password=nil)
    @coach = coach
    @password = password if password.present?
    mail to: coach.emails
  end

  def membership_application_created(membership_application)
    @user = membership_application.user
    mail to: @user.emails
  end

  ### 無料体験機能追加メール

  def payment_method_changed(user)
    @user = user
    mail to: @user.emails
  end

  def premium_registration_with_credit_card(user)
    @user = user
    mail to: @user.emails
  end

  def yucho_account_application_created(user)
    @user = user
    mail to: @user.emails
  end

  def yucho_account_application_accepted(user)
    @user = user
    mail to: @user.emails
  end

  def yucho_account_application_rejected(user)
    @user = user
    mail to: @user.emails
  end

  def membership_application_created_at_free_user(membership_application)
    @user = membership_application.user
    mail to: @user.emails
  end

  def premium_registration_with_yucho(user)
    @user = user
    mail to: @user.emails
  end
end
