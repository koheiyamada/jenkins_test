# coding:utf-8

class TrialLesson < OptionalLesson

  def style
    :trial
  end

  def units_select_options
    (1 .. LessonSettings.max_units_of_trial_lesson).to_a
  end

  def fix!
    super
    accept!
  end

  def fix
    super
    accept
  end

  def establish
    unless established?
      logger.info 'TrialLesson#established is called, but nothing happens because the trial lesson should not be charged.'
    end
  end

  # 終了予定時刻まで入室可能とする
  def entry_end_time_for(user)
    end_time
  end

  def has_option_to_extend?
    false
  end

  # 体験レッスンでは料金を発生させない
  def journalize!
    # do nothing
  end

  def should_check_student_paying_capacity?
    false
  end

  def cancellable_by_tutor?
    false
  end

  private

    def send_mail_on_status_change
      if status_changed?
        if accepted?
          if status_was == 'new'
            Mailer.send_mail_async(:optional_lesson_accepted, self)
          end
        end
      end
    end

    def within_tutor_daily_available_times?
      true # デモレッスンの登録はレッスン可能日時指定を無視する
    end

    def ensure_before_time_limit_of_acceptance
      # チューターがレッスンを引き受ける時間に制約を入れない
    end
end
