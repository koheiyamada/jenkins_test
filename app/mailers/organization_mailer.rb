class OrganizationMailer < ActionMailer::Base
  layout 'mail'

  def optional_lesson_accepted(lesson)
    @lesson = lesson
    emails = lesson.organization_emails
    mail to:emails
  end

  def optional_lesson_rejected(lesson)
    @lesson = lesson
    emails = lesson.organization_emails
    mail to:emails
  end

  def basic_lesson_info_accepted(basic_lesson_info)
    @basic_lesson_info = basic_lesson_info
    mail to:basic_lesson_info.organization_emails
  end

  def basic_lesson_info_rejected(basic_lesson_info)
    @basic_lesson_info = basic_lesson_info
    mail to: basic_lesson_info.organization_emails
  end

  def basic_lesson_info_closed(basic_lesson_info)
    @basic_lesson_info = basic_lesson_info
    mail to: basic_lesson_info.organization_emails
  end

  def student_updated(student)
    @student = student
    if student.organization
      mail to:student.organization.emails
    end
  end

  def parent_updated(parent)
    @parent = parent
    emails = parent.organization_emails
    if emails.present?
      mail to:emails
    end
  end

  def coach_created(coach, password=nil)
    @coach = coach
    @password = password if password.present?
    bs = coach.organization
    if bs.present?
      emails = bs.emails
      if emails.present?
        mail to: emails
      end
    end
  end
end
