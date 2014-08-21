# coding:utf-8
module LessonRoomMethods
  # 生徒がレッスン部屋ページを開いた時にこれを呼ぶこと
  def student_entered(student)
    if students.include?(student)
      lesson_students.find_by_student_id(student.id).enter
    end
  end

  def entered_students
    students.where('lesson_students.entered_at IS NOT NULL')
  end

  # 生徒がスタートボタンを押した時にこれを呼ぶこと
  def student_attended(student)
    if students.include?(student)
      transaction do
        lesson_students.find_by_student_id(student.id).attend!
        on_member_attended(student)
      end
    end
  end

  # レッスンに参加した記録のある、チューターを含む全参加者
  def attended_members
    members = []
    if tutor_attended_at.present?
      members << tutor
    end
    members + attended_students.to_a
  end

  def attended_member_ids
    attended_members.map{|member| member.id}
  end

  # チューターが「開始ボタン」を押した時に呼ぶこと
  def tutor_attended
    if tutor_attended_at.blank?
      transaction do
        touch(:tutor_attended_at)
        on_member_attended(tutor)
        logger.lesson_log('TUTOR_ATTENDED', log_attributes)
      end
    end
  end

  # 参加者が全員揃っていればtrueを返す
  # 事前にキャンセルをした受講者がいる場合はそれを除いた全員が揃っていればtrueを返す。
  def all_members_attended?
    tutor_attended_at.present? && lesson_students.remaining.all?{|student| student.attended_at.present?}
  end

  def has_enough_members_to_start?
    tutor_attended_at.present? && lesson_students.remaining.any?{|student| student.attended_at.present?}
  end

  # チューターがレッスン画面を開いた時に呼ぶこと
  def tutor_entered
    touch(:tutor_entered_at)
    logger.lesson_log('TUTOR_ENTERED', lesson_id:id, tutor_id:tutor.id, tutor_user_name:tutor.user_name)
  end

  def tutor_entered?
    tutor_entered_at.present?
  end

  def student_left(student)
    lesson_student = lesson_students.find_by_student_id(student.id)
    if lesson_student
      lesson_student.leave
      logger.lesson_log('STUDENT_LEFT', lesson_id:id, student_id:student.id, student_user_name:student.user_name)
    else
      false
    end
  end

  def student_left?(student)
    student(student).dropped_out?
  end

  def student_cancelled?(student)
    lesson_student = student(student)
    lesson_student.present? && lesson_student.cancelled?
  end

  # 生徒がレッスン画面を開いたことがあればtrueを返す
  def student_attended?(student)
    if students.include?(student)
      lesson_students.find_by_student_id(student.id).attended?
    else
      false
    end
  end

  # レッスンを開始できる状態であればtrueを返す
  # 現在開催待ち && 開催可能時間 && 参加予定者が全員揃っている
  def ready_to_start?
    accepted? && time_enable_to_start? && has_enough_members_to_start?
  end
end