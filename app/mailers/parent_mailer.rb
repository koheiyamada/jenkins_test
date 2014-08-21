# coding: utf-8

class ParentMailer < UserMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.parent_mailer.optional_lesson_requested.subject
  #
  def optional_lesson_requested(lesson, student)
    @lesson = lesson
    @student = student
    if student.parent.present?
      mail to: student.parent.emails
    end
  end

  def basic_lesson_info_activated(basic_lesson_info, student)
    @basic_lesson_info = basic_lesson_info
    @student = student
    if student.parent.present?
      mail to: student.parent.emails
    end
  end

  def student_created(student, password=nil)
    if student.parent.present?
      @student = student
      @password = password if password.present?
      @parent = student.parent
      if @student.free?
        mail to: @parent.emails, subject: "[AID Tutoring System]無料会員登録完了のお知らせ"
      else
        mail to: @parent.emails
      end
    end
  end

  def cs_report_not_written(lesson, student)
    @student = student
    @lesson = lesson
    if student.parent.present?
      mail to: student.parent.emails
    end
  end

  def charge_limit_reached(student, reason)
    @student = student
    if student.parent.present?
      mail to: student.parent.emails
    end
  end

  def lesson_coming_notification(lesson, student)
    @lesson = lesson
    @student = student
    if student.parent.present?
      mail to: student.parent.emails
    end
  end

  def lesson_started(lesson, student)
    @lesson = lesson
    @student = student
    if student.parent.present?
      mail to: student.parent.emails
    end
  end

  def lesson_ended(lesson, student)
    @lesson = lesson
    if student.parent.present?
      mail to: student.parent.emails
    end
  end

  def charge_limit_approaching(student, year, month)
    if student.parent.present?
      @year = year
      @month = month
      @student = student
      mail to:student.parent.emails
    end
  end

  def meeting_skipped(parent, meeting)
    @parent = parent
    @meeting = meeting
    mail to: parent.emails
  end

  def membership_cancelled(parent)
    @parent = parent
    mail to:parent.emails
  end

  def membership_application_rejected(parent)
    @parent = parent
    mail to: parent.emails
  end

  def meeting_registered(parent, meeting)
    @parent = parent
    @meeting = meeting
    mail to: parent.emails
  end

  def monthly_payment_fixed(parent, monthly_statement)
    @parent = parent
    @month = monthly_statement.month
    mail to: parent.emails, subject: I18n.t('mail_titles.monthly_payment_fixed.subject', x: @month)
  end

  def lesson_skipped(parent, lesson_student, lesson)
    @parent = parent
    @student = lesson_student.student
    @lesson = lesson
    template_name = lesson_student.entered? ? 'lesson_skipped_because_of_tutor' : 'lesson_skipped_because_of_student'
    mail to: parent.emails, template_name: template_name
  end

  def lesson_skipped_because_of_tutor(parent, student, lesson)
    lesson_mail parent, student, lesson
  end

  def lesson_skipped_because_of_student(parent, student, lesson)
    lesson_mail parent, student, lesson
  end

  def email_confirmation_by_parent(email,token)
    @confirmation_token = token
    mail to:(email) do |format|
      format.text { render layout: 'mail_for_nonuser' }
    end
  end

  def change_email_parent(email,token)
    @confirmation_token = token
    mail to:(email) do |format|
      format.text { render layout: 'mail_for_nonuser' }
    end
  end

  def user_email_changed(parent)
    @parent = parent
    mail to: parent.emails
  end

  private

    def lesson_mail(parent, student, lesson)
      @parent = parent
      @student = student
      @lesson = lesson
      mail to: @student.emails
    end
end
