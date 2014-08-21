class TutorMailer < UserMailer
  #default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.tutor_mailer.lesson_request_arrived.subject
  #

  def optional_lesson_requested(lesson)
    @lesson = lesson
    mail to: lesson.tutor.emails
  end

  def optional_lesson_accepted(lesson)
    @lesson = lesson
    mail to: lesson.tutor.emails
  end

  def optional_lesson_rejected(lesson)
    @lesson = lesson
    mail to: lesson.tutor.emails
  end

  def basic_lesson_info_accepted(basic_lesson_info)
    @basic_lesson_info = basic_lesson_info
    mail to:basic_lesson_info.organization_emails
  end

  def basic_lesson_info_rejected(basic_lesson_info)
    @basic_lesson_info = basic_lesson_info
    mail to:basic_lesson_info.organization_emails
  end

  def basic_lesson_info_closed(basic_lesson_info)
    @basic_lesson_info = basic_lesson_info
    mail to: basic_lesson_info.tutor.emails
  end

  def optional_lesson_ignored(lesson)
  end

  def basic_lesson_info_activated(basic_lesson_info)
  end

  def lesson_coming_notification(lesson)
    @lesson = lesson
    mail to: lesson.tutor.emails
  end

  def lesson_schedule_change_requested(lesson)
    @lesson = lesson
    mail to: lesson.tutor.emails
  end

  def lesson_cancelled(lesson)
    @lesson = lesson
    mail to: lesson.tutor.emails
  end

  def did_cancel_lesson(tutor_lesson_cancellation)
    @tutor_lesson_cancellation = tutor_lesson_cancellation
    @lesson = tutor_lesson_cancellation.lesson
    @tutor = @lesson.tutor
    mail to: @lesson.tutor.emails
  end

  def student_lesson_cancelled(lesson_cancellation)
    @lesson_cancellation = lesson_cancellation
    @student = lesson_cancellation.student
    @lesson = lesson_cancellation.lesson
    mail to: @lesson.tutor.emails
  end

  def tutor_created(tutor, password=nil)
    @tutor = tutor
    @password = password if password.present?
    mail to: tutor.emails
  end

  def lesson_request_arrived(lesson)
    @lesson = lesson
    mail to: lesson.tutor.emails
  end

  def being_locked(tutor)
    @tutor = tutor
    mail to: tutor.emails
  end

  def tutor_become_regular(tutor)
    @tutor = tutor
    mail to: tutor.emails
  end

  def membership_cancelled(tutor)
    @tutor = tutor
    mail to:tutor.emails
  end

  def meeting_registered(tutor, meeting)
    @tutor = tutor
    @meeting = meeting
    mail to: tutor.emails
  end

  def meeting_skipped(user, meeting)
    @user = user
    @meeting = meeting
    mail to: user.emails
  end

  def lesson_skipped(tutor, lesson)
    @tutor = tutor
    @lesson = lesson
    template_name = lesson.tutor_entered? ? 'lesson_skipped_because_of_tutor' : 'lesson_skipped_because_of_student'
    mail to: tutor.emails, template_name: template_name
  end

  def lesson_skipped_because_of_tutor(tutor, lesson)
    lesson_mail tutor, lesson
  end

  def lesson_skipped_because_of_student(tutor, lesson)
    lesson_mail tutor, lesson
  end

  def change_email_tutor(email,token)
    @confirmation_token = token
    mail to:(email) do |format|
      format.text { render layout: 'mail_for_nonuser' }
    end
  end

  private

    def lesson_mail(tutor, lesson)
      @tutor = tutor
      @lesson = lesson
      mail to: @tutor.emails
    end

end
