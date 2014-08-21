# -*- encoding: utf-8 -*- #
class StudentMailer < UserMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.student_mailer.optional_lesson_requested.subject
  #
  def optional_lesson_requested(lesson)
    @lesson = lesson
    mail to: lesson.student_emails
  end

  def optional_lesson_accepted(lesson)
    @lesson = lesson
    mail to: lesson.student_emails
  end

  def optional_lesson_rejected(lesson)
    @lesson = lesson
    mail to: lesson.student_emails
  end

  def optional_lesson_ignored(lesson)
    @lesson = lesson
    mail to: lesson.student_emails
  end

  def basic_lesson_info_activated(basic_lesson_info)
    @basic_lesson_info = basic_lesson_info
    mail to: @basic_lesson_info.student_emails
  end

  def basic_lesson_info_closed(basic_lesson_info, student)
    @basic_lesson_info = basic_lesson_info
    @student = student
    mail to: student.emails
  end

  def lesson_coming_notification(lesson)
    @lesson = lesson
    mail to: lesson.student_emails
  end

  def lesson_schedule_change_requested(lesson)
    @lesson = lesson
    mail to: lesson.student_emails
  end

  def invited_to_optional_lesson(lesson)
    @lesson = lesson
    mail to: lesson.friend.emails
  end

  def lesson_invitation_rejected(lesson, student)
    @lesson = lesson
    @student = student
    mail to: lesson.student_emails
  end

  def lesson_cancelled(student, lesson)
    @lesson = lesson
    mail to: student.emails
  end

  # 自分がレッスンをキャンセルしたときの通知
  def did_cancel_lesson(lesson_cancellation)
    @lesson_cancellation = lesson_cancellation
    @lesson = lesson_cancellation.lesson
    @student = lesson_cancellation.student
    mail to: @student.emails
  end

  def tutor_lesson_cancelled(student, tutor_lesson_cancellation)
    @tutor_lesson_cancellation = tutor_lesson_cancellation
    @lesson = tutor_lesson_cancellation.lesson
    @tutor = @lesson.tutor
    mail to: student.emails
  end

  def student_lesson_cancelled(student, lesson_cancellation)
    @lesson_cancellation = lesson_cancellation
    @student = lesson_cancellation.student
    @lesson = lesson_cancellation.lesson
    mail to: student.emails
  end

  def student_created(student, password=nil)
    @student = student
    @password = password if password.present?
    if @student.free?
      mail to: student.emails, subject: "[AID Tutoring System]無料会員登録完了のお知らせ"
    else
      mail to: student.emails
    end
  end

  def cs_report_not_written(lesson, student)
    @student = student
    @lesson = lesson
    mail to: student.emails
  end

  def charge_limit_reached(student)
    if student.independent?
      @student = student
      mail to: student.parent.emails
    end
  end

  def charge_limit_approaching(student, year, month)
    if student.independent?
      @year = year
      @month = month
      @student = student
      mail to: student.emails
    end
  end

  def favorite_tutor_weekday_schedules_changed(tutor, student)
    @tutor = tutor
    @student = student
    mail to: student.emails
  end

  def membership_cancelled(student)
    @student = student
    mail to: student.emails
  end

  def membership_application_rejected(student)
    @student = student
    mail to: student.emails
  end

  def meeting_registered(student, meeting)
    @student = student
    @meeting = meeting
    mail to: student.emails
  end

  def meeting_skipped(student, meeting)
    @student = student
    @meeting = meeting
    mail to: student.emails
  end

  def monthly_payment_fixed(student, monthly_statement)
    @student = student
    @month = monthly_statement.month
    mail to: student.emails, subject: I18n.t('mail_titles.monthly_payment_fixed.subject', x: @month)
  end

  def lesson_skipped_because_of_tutor(student, lesson)
    lesson_mail student, lesson
  end

  def lesson_skipped_because_of_student(student, lesson)
    lesson_mail student, lesson
  end

  def change_email_student(email,token)
    @confirmation_token = token
    mail to:(email) do |format|
      format.text { render layout: 'mail_for_nonuser' }
    end
  end

  private

    def lesson_mail(student, lesson)
      @student = student
      @lesson = lesson
      mail to: @student.emails
    end
end
