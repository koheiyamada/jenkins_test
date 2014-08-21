# coding:utf-8

class HqUserMailer < UserMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.hq_user_mailer.optional_lesson_requested.subject
  #
  def optional_lesson_requested(lesson)
    @lesson = lesson
    mail to: Headquarter.instance.emails
  end

  def optional_lesson_accepted(lesson)
  end

  def optional_lesson_rejected(lesson)
  end

  def optional_lesson_ignored(lesson)
  end

  def basic_lesson_info_activated(basic_lesson_info)
    @basic_lesson_info = basic_lesson_info
    mail to: Headquarter.instance.emails
  end

  def bs_user_registered(bs_user, password=nil)
    @bs_user = bs_user
    @password = password
    mail to: Headquarter.instance.emails
  end

  def bs_app_form_accepted(bs_app_form)
    @bs_app_form = bs_app_form
    mail to: Headquarter.instance.emails
  end

  def tutor_app_form_accepted(tutor_app_form)
    @tutor_app_form = tutor_app_form
    mail to: Headquarter.instance.emails
  end

  def tutor_created(tutor, password=nil)
    @tutor = tutor
    mail to: Headquarter.instance.emails
  end

  def student_created(student, password=nil)
    @student = student
    mail to: Headquarter.instance.emails
  end

  def student_updated(student)
    @student = student
    mail to: Headquarter.instance.emails
  end

  def student_no_bs_found(student)
    @student = student
    mail to: Headquarter.instance.emails
  end

  def student_organization_changed(student, prev_organization=nil)
    @student = student
    @prev_organization = prev_organization
    mail to: Headquarter.instance.emails
  end

  def parent_created(parent)
    @parent = parent
    mail to: Headquarter.instance.emails
  end

  def parent_updated(parent)
    @parent = parent
    mail to: Headquarter.instance.emails
  end

  def hq_user_created(hq_user)
    @hq_user = hq_user
    mail to: Headquarter.instance.emails
  end

  def membership_cancelled(user)
    @user = user
    mail to: Headquarter.instance.emails
  end

  def membership_application_rejected(membership_application)
    @user = membership_application.user
    mail to: Headquarter.instance.emails
  end

  # 面談の参加者が希望の日程を選択したことを通知する
  def meeting_schedule_selected(user, meeting_member, schedule)
    @user = user
    @meeting = meeting_member.meeting
    @member = meeting_member.user
    @schedule = schedule
    mail to: user.emails
  end

  def meeting_skipped(user, meeting)
    @user = user
    @meeting = meeting
    mail to: user.emails
  end

  def coach_created(coach, password=nil)
    @coach = coach
    @password = password if password.present?
    mail to: Headquarter.instance.emails
  end

  def membership_application_created(membership_application)
    @user = membership_application.user
    mail to: Headquarter.instance.emails
  end

  def change_email_hq_user(email,token)
    @confirmation_token = token
    mail to:(email) do |format|
      format.text { render layout: 'mail_for_nonuser' }
    end
  end

end
