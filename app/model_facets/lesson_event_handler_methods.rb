# coding: utf-8

module LessonEventHandlerMethods
  def self.included(base)
    base.after_update :on_extended, if: :extended_changed?
  end

  # このレッスンのCSシートが作成されたときに呼ばれる
  def on_cs_sheet_created(cs_sheet)
    if cs_sheet.lesson == self
      transaction do
        # CSシートが揃ったらCSポイントを計算する
        if cs_sheets_collected?
          update_column :cs_sheets_collected, true
          update_column :cs_point, calculate_cs_point
          tutor.on_lesson_score_settled(self)
        end

        tutor.on_cs_sheet_created(cs_sheet)
      end
    end
  end

  def on_extended
    if extended?
      reset_closing_process
      true
    end
  end

  # 生徒がレッスンをキャンセルしたときに呼び出される。
  # 参加している生徒がゼロ人になったらレッスン自体をキャンセルする。
  def on_student_cancelled(lesson_student)
    if lesson_students.remaining.empty?
      cancel(lesson_student.student)
      logger.lesson_log('CANCELLED_BECAUSE_NO_STUDENTS')
    end
  end

  def on_student_dropped_out(lesson_student)
    if lesson_students.remaining.empty?
      abort
      logger.lesson_log('CLOSED_BECAUSE_NO_STUDENTS')
    end
  end

  # レッスンの入室制限時刻（開始予定時刻の１０分後）に呼ばれる
  def on_door_closed
    # 何もしない
  end

  # チューター入室開始時刻に呼ばれる
  def on_tutor_entry_start_time
    if under_request?
      ignore!
    end
  end

  # チューター入室締切時刻に呼ばれる
  # チューターが入室済で、レッスンが始まっていない場合は開始する。
  def on_tutor_entry_end_time
    if tutor_entered?
      if started?
        # 何もしない
      else
        # 自動的にレッスンを開始する
        open_and_notify
      end
    else
      # チューターが入室締切時刻までに入室しなかった
      tutor_not_show_up
    end
  end

  # 受講者入室終了時刻に呼ばれる
  def on_student_entry_start_time
    # 何もしない
  end

  # 受講者入室締切時刻に呼ばれる
  def on_student_entry_end_time
    # 何もしない
  end

  # 途中キャンセル締切時刻に呼ばれる
  # レッスンが開始されないと、途中キャンセル時刻が設定されないので、この処理が呼ばれることはないはず。
  def on_dropout_closing_time
    if started?
      establish # 必ずここに来る
    else
      logger.error 'レッスンが開始していないのに途中キャンセル時刻の処理が実行された'
      logger.error log_attributes
      if tutor_entered?
        establish
        open_and_notify
      end
    end
  end

  private

    # レッスン開始時に呼ばれる
    def on_started
      send_started_mail
      reset_closing_process
      reset_dropout_time_limit
    end

    def send_started_mail
      # 保護者にメール
      students.each do |student|
        Mailer.send_mail(:lesson_started, self, student)
      end
    rescue => e
      logger.error e
    end

    # レッスン終了時に呼ばれる
    def on_ended
      # 保護者にメール
      students.each do |student|
        Mailer.send_mail(:lesson_ended, self, student)
      end
    end

    # レッスンが開始前にキャンセルされた時に呼ばれる
    def on_cancelled
      Mailer.send_mail(:lesson_cancelled, self)
      cleanup_on_cancellation
    end

    # レッスン画面を参加者が開いた時に呼ばれる
    def on_member_attended(user)
      # すべてのメンバーがそろったらレッスン開始状態に移行する
      if has_enough_members_to_start?
        start!
      end
      # 既に参加しているメンバーに通知する
      delay.notify_member_attended(user.id)
    end

    def notify_member_attended(user_id)
      notify_to_attendees('MEMBER_ATTENDED', user: {id: user_id})
    rescue => e
      logger.error e
    end

    # レッスンの開催が確定した時に呼ばれる。
    def on_accepted
      # 実装はサブクラス
    end

    # レッスンの料金支払いが確定した時に呼ばれる
    def on_established
      students.each do |student|
        student.delay.on_monthly_charge_updated(settlement_year, settlement_month)
      end
    end

    # @note レッスンが開始されなかった時に呼ばれる
    def on_skipped
      send_lesson_skipped_emails
    end

    def send_lesson_skipped_emails
      Mailer.send_mail :lesson_skipped, self
    end

    # @note レッスンが終了した時に呼ばれる
    def on_done
      logger.lesson_log('DONE', log_attributes)
      notify_status_change_to_attendees if status_was == Lesson::Status::OPEN
      tutor.on_lesson_done(self)
      send_at(Lesson.follow_up_at, :follow_up)
    end
end