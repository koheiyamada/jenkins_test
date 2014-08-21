module InvitableLesson
  def self.included(base)
    base.has_one :lesson_invitation, :foreign_key => :lesson_id, :dependent => :delete
    base.has_one :invited_student, :through => :lesson_invitation, :source => :student
  end

  def invite!(student)
    unless students.include?(student)
      create_lesson_invitation!(student: student)
    end
  end

  def invite(student)
    create_lesson_invitation(student: student)
  end

  def invited_student?(student)
    lesson_invitation.present? && lesson_invitation.student_id == student.id
  end

  def no_reply_invitees
    Student.joins(:lesson_invitations).where(lesson_invitations: {lesson_id: id, status: 'new'})
  end

  def invitation_accepted(student)
    if invited_student? student
      lesson_invitation.accept
    end
  end

  # studentが招待相手の場合は招待者から削除する
  def invitation_rejected(student)
    if invited_student? student
      lesson_invitation.reject
      Mailer.send_mail(:lesson_invitation_rejected, self, student)
    end
  end
end
