module LessonTimeMethods

  # 現在時刻が、参加メンバー全体で最初に入室可能となる時刻よりも前であればtrueを返す
  def before_entry_start_time?
    Time.current < earliest_entry_start_time
  end

  def before_entry_start_time_for?(user)
    Time.current < entry_start_time_for(user)
  end

  # 現在userが入室可能な時間帯であればtrueを返す
  def period_to_enter_for?(user)
    Lesson.anytime_enterable || period_to_enter(user).cover?(Time.current)
  end

  # userが入室可能な時間帯を返す
  def period_to_enter(user)
    entry_start_time_for(user) .. entry_end_time_for(user)
  end

  def wday
    start_time.wday
  end

  # チューターの入室開始時刻
  def tutor_entry_start_time
    LessonSettings.tutor_entry_period_before_start_time.minutes.ago(start_time)
  end

  # チューターの入室締切時刻
  def tutor_entry_end_time
    LessonSettings.tutor_entry_period_after_start_time.minutes.since(start_time)
  end

  # 受講者の入室開始時刻
  def student_entry_start_time
    LessonSettings.student_entry_period_before_start_time.minutes.ago(start_time)
  end

  # 受講者の入室締切時刻
  def student_entry_end_time
    LessonSettings.student_entry_period_after_end_time.minutes.since(end_time)
  end

  # メンバーが揃わなくても自動的にレッスンが開始する時刻
  def auto_start_time
    tutor_entry_end_time
  end

  # 途中キャンセル締切時刻
  # レッスンが開始していない段階ではnilを返す
  def dropout_closing_time
    if started_at
      @dropout_closing_time ||= LessonSettings.dropout_limit.minutes.since([started_at, start_time].max)
    end
  end

  def dropout_closed?
    dropout_closing_time.present? &&
    Time.current > dropout_closing_time
  end

  # 入室開始時刻
  def earliest_entry_start_time
    @earliest_entry_start_time ||= entry_start_times.min
  end

  def entry_start_times
    [tutor_entry_start_time, student_entry_start_time]
  end

  def time_enable_to_start?
    entry_start_times.max <= Time.current
  end

  def entry_start_time_for(user)
    if user.student?
      student_entry_start_time
    elsif user.tutor?
      tutor_entry_start_time
    else
      start_time
    end
  end

  def entry_end_time_for(user)
    if user.student?
      student_entry_end_time
    elsif user.tutor?
      tutor_entry_end_time
    else
      time_lesson_end
    end
  end

  def request_time_limit
    LessonSettings.request_time_limit.minutes.ago(start_time)
  end

  def request_acceptance_time_limit
    LessonSettings.request_acceptance_time_limit.minutes.ago(start_time)
  end

  # 実際の開始時刻による補正を反映した終了予定時刻
  def corrected_end_time
    if started_at.present?
      [end_time, duration.minutes.since(started_at)].max
    else
      end_time
    end
  end

  # 実際の終了予定時刻（実際の開始時刻に依存する）
  # レッスンの延長が成立した場合は延長後の時間を返す。
  def time_lesson_end
    if extended?
      end_time_after_extended
    else
      corrected_end_time
    end
  end

  def time_to_check_lesson_extension
    started_at && Lesson.time_to_check_lesson_extension.minutes.ago(corrected_end_time)
  end

  def time_room_close
    LessonSettings.period_to_close_room_after_end_time.minutes.since(time_lesson_end)
  end

  def who_cancelled
    User.find_by_id(cancelled_by)
  end

  # 延長をした場合の終了時間
  def end_time_after_extended
    Lesson.extension_duration.minutes.since(corrected_end_time)
  end

  def cancellation_time_limit_for_tutor
    Lesson.cancellation_time_limit_for_tutor(self)
  end
end