module LessonInvitationsHelper
  def lesson_invitation_accepting?(lesson_invitation)
    lesson = lesson_invitation.lesson
    lesson.going_to_be_held?
  end

  def lesson_invitation_status(lesson_invitation)
    content_tag :span, class: 'status' do
      content_tag :i, '', class: lesson_invitation_status_class(lesson_invitation)
    end
  end

  def lesson_invitation_status_string(lesson_invitation)
    content_tag :span, class: 'status-string' do
      concat t("lesson_invitation.statuses.#{lesson_invitation.status}")
    end
  end

  def lesson_invitation_status_class(lesson_invitation)
    case lesson_invitation.status
    when 'accepted' then 'icon-ok'
    when 'rejected' then 'icon-remove'
    else 'blank'
    end
  end
end