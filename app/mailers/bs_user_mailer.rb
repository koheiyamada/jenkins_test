class BsUserMailer < UserMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.bs_user_mailer.optional_lesson_requested.subject
  #
  def optional_lesson_requested(lesson)
    @lesson = lesson
    student = lesson.students.first
    if student
      organization = student.organization
      if organization && organization.is_a?(Bs)
        mail to: organization.emails
      end
    end
  end

  def optional_lesson_accepted(lesson)
  end

  def optional_lesson_rejected(lesson)
  end

  def optional_lesson_ignored(lesson)
  end

  def basic_lesson_info_activated(basic_lesson_info, student)
    @basic_lesson_info = basic_lesson_info
    mail to: student.organization_emails
  end

  def bs_user_registered(bs_user, password=nil)
    @bs_user = bs_user
    @password = password
    mail to: bs_user.emails
  end

  def student_created(student, password=nil)
    @student = student
    if student.organization && student.organization.bs?
      mail to: student.organization_emails
    end
  end

  def student_updated(student)
    @student = student
    if student.organization && student.organization.bs?
      mail to: student.organization_emails
    end
  end

  def parent_updated(parent)
    @parent = parent
    emails = parent.organization_emails
    if emails.present?
      mail to: emails
    end
  end

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

  def tutor_lesson_cancelled(coach, student, tutor_lesson_cancellation)
    @coach = coach
    @student = student
    @tutor_lesson_cancellation = tutor_lesson_cancellation
    @lesson = tutor_lesson_cancellation.lesson
    @tutor = @lesson.tutor
    mail to: coach.emails
  end

  def change_email_bs_user(email,token)
    @confirmation_token = token
    mail to:(email) do |format|
      format.text { render layout: 'mail_for_nonuser' }
    end
  end

end
