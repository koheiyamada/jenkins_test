module Mailer
  extend self

  def send_mail(mail_type, *args)
    if Rails.env.test?
      send_mail_sync mail_type, *args
    else
      send_mail_async mail_type, *args
    end
  end

  def send_mail_async(mail_type, *args)
    delay.send_mail_sync(mail_type, *args)
  end

  def send_mail_sync(mail_type, *args)
    send mail_type, *args
    Rails.logger.info "SENT MAIL #{mail_type} #{args}"
  rescue Exception => e
    Rails.logger.error e
    Rails.logger.error "FAILED TO SEND MAIL #{mail_type} #{args}"
  end

  def send_mail_at(time, mail_type, *args)
    Delayed::Job.enqueue(
      Delayed::PerformableMethod.new(self, mail_type.to_sym, *args),
      run_at: time)
  end

  def send_mail_at_appropriate_time(mail_type, *args)
    send_mail_at next_appropriate_time, mail_type, *args
  end

  def next_appropriate_time
    if now_is_ok_to_send_mail?
      Time.current
    else
      time_next_morning
    end
  end

  def now_is_ok_to_send_mail?
    SystemSettings.hour_range_for_sending_mail.include?(Time.current.hour)
  end

  def time_next_morning
    range = SystemSettings.hour_range_for_sending_mail
    h = Time.current.hour
    if h >= range.first
      Date.tomorrow.to_time.change(hour: range.first)
    else
      Date.today.to_time.change(hour: range.first)
    end
  end

  def logging(&block)
    block.call
    Rails.logger.info "SENT MAIL #{mail_type} #{args}"
  rescue => e
    Rails.logger.error e
  end

  #
  # Mail sending methods
  #

  def did_cancel_lesson(user, lesson)
    if user.student?
      StudentMailer.did_cancel_lesson(user, lesson).deliver
    end
  end

  def membership_application_created(membership_application)
    UserMailer.membership_application_created(membership_application).deliver
    HqUserMailer.membership_application_created(membership_application).deliver
  end

  def being_locked(tutor)
    TutorMailer.being_locked(tutor).deliver
  end

  def lesson_skipped(lesson)
    # 受講者と保護者とチューターにメールを送る
    message = lesson.tutor_entered? ? :lesson_skipped_because_of_student : :lesson_skipped_because_of_tutor
    lesson.lesson_students.remaining.each do |lesson_student|
      student = lesson_student.student
      StudentMailer.send(message, student, lesson).deliver
      if student.parent.present?
        ParentMailer.send(message, student.parent, student, lesson).deliver
      end
    end
    TutorMailer.send(message, lesson.tutor, lesson).deliver
  end

  # レッスンそのものがキャンセルされたことを通知する。
  # チューターによってキャンセルされた場合は tutor_lesson_cancelled を呼ぶ
  def lesson_cancelled(lesson)
    if lesson.cancelled_by_tutor?
      tutor_lesson_cancelled lesson.tutor_lesson_cancellation
    else
      lesson.active_students.each do |student|
        StudentMailer.lesson_cancelled(student, lesson).deliver
      end
      TutorMailer.lesson_cancelled(lesson).deliver
    end
  end

  def basic_lesson_info_closed(basic_lesson_info)
    TutorMailer.basic_lesson_info_closed(basic_lesson_info).deliver
    basic_lesson_info.students.each do |student|
      StudentMailer.basic_lesson_info_closed(basic_lesson_info, student).deliver
    end
    OrganizationMailer.basic_lesson_info_closed(basic_lesson_info).deliver
  end

  # 受講者がレッスンをキャンセルしたことを通知する
  # 受講者本人にも通知する
  # レッスンに参加している別の受講者にも通知する
  def student_lesson_cancelled(lesson_cancellation)
    TutorMailer.student_lesson_cancelled(lesson_cancellation).deliver
    StudentMailer.did_cancel_lesson(lesson_cancellation).deliver
    lesson_cancellation.lesson.active_students.each do |student|
      StudentMailer.student_lesson_cancelled(student, lesson_cancellation).deliver
    end
  end

  def optional_lesson_requested(lesson)
    TutorMailer.optional_lesson_requested(lesson).deliver
    StudentMailer.optional_lesson_requested(lesson).deliver
    if lesson.friend.present?
      StudentMailer.invited_to_optional_lesson(lesson).deliver
    end
    BsUserMailer.optional_lesson_requested(lesson).deliver
    lesson.students.each do |student|
      ParentMailer.optional_lesson_requested(lesson, student)
    end
  end

  def optional_lesson_accepted(lesson)
    StudentMailer.optional_lesson_accepted(lesson).deliver
    OrganizationMailer.optional_lesson_accepted(lesson).deliver
    BsUserMailer.optional_lesson_accepted(lesson).deliver
  end

  def optional_lesson_rejected(lesson)
    StudentMailer.optional_lesson_rejected(lesson).deliver
    OrganizationMailer.optional_lesson_rejected(lesson).deliver
    unless lesson.organizations.include?(Headquarter.instance)
      HqUserMailer.optional_lesson_rejected(lesson).deliver
    end
    TutorMailer.optional_lesson_rejected(lesson).deliver
  end

  def optional_lesson_ignored(lesson)
    StudentMailer.optional_lesson_ignored(lesson).deliver
    BsUserMailer.optional_lesson_ignored(lesson).deliver
    HqUserMailer.optional_lesson_ignored(lesson).deliver
  end

  def basic_lesson_info_activated(basic_lesson_info)
    StudentMailer.basic_lesson_info_activated(basic_lesson_info).deliver
    HqUserMailer.basic_lesson_info_activated(basic_lesson_info).deliver
    basic_lesson_info.students.each do |student|
      ParentMailer.basic_lesson_info_activated(basic_lesson_info, student).deliver
      BsUserMailer.basic_lesson_info_activated(basic_lesson_info, student).deliver
    end
  end

  def message_created(message)
    message.recipients.each do |recipient|
      begin
        UserMailer.delay.message_created(message, recipient)
      rescue => e
        Rails.logger.error e
      end
    end
    MonitoringMailer.delay.message_created(message)
  end

  def lesson_coming_notification(lesson)
    TutorMailer.lesson_coming_notification(lesson).deliver
    StudentMailer.lesson_coming_notification(lesson).deliver
    lesson.students.each do |student|
      ParentMailer.lesson_coming_notification(lesson, student).deliver
    end
  end

  def favorite_tutor_weekday_schedules_changed(tutor)
    tutor.students_favored_by.each do |student|
      StudentMailer.favorite_tutor_weekday_schedules_changed(tutor, student).deliver
    end
  end

  def membership_cancelled(user)
    user.send_mail :membership_cancelled
    HqUserMailer.membership_cancelled(user).deliver
  end

  def membership_application_rejected(membership_application)
    membership_application.user.send_mail :membership_application_rejected
    HqUserMailer.membership_application_rejected(membership_application).deliver
  end

  def meeting_registered(meeting)
    meeting.members.each do |member|
      if meeting.creator != member
        member.send_mail :meeting_registered, meeting
      end
    end
  end

  def meeting_schedule_selected(meeting_member, schedule)
    meeting = meeting_member.meeting
    meeting.creator.send_mail :meeting_schedule_selected, meeting_member, schedule
  end

  # メール送信タスクを定義する
  # 具体的には、
  # 「引数に与えられたActionMailerのサブクラスそれぞれのnameメソッドを呼び出すメソッド」
  # を定義する。
  def define_mailer_task(name, *mailers)
    define_method(name) do |*args|
      mailers.each do |mailer|
        begin
          mailer.send(name, *args).deliver
        rescue => e
          Rails.logger.error(e)
        end
      end
    end
  end

  def coach_created(coach, password=nil)
    HqUserMailer.coach_created(coach, password).deliver
    UserMailer.coach_created(coach, password).deliver
    bs = coach.organization
    if bs && bs.is_a?(Bs)
      OrganizationMailer.coach_created(coach, password).deliver
    end
  end
  
  #無料会員機能 追加メール
  define_mailer_task :payment_method_changed, UserMailer #=> 支払方法変更成功時に送信
  define_mailer_task :premium_registration_with_credit_card, UserMailer #=> クレジットカードで一般会員登録した時送信
  define_mailer_task :yucho_account_application_created, UserMailer #=> 郵貯へ支払方法を変更する申込をした時送信
  define_mailer_task :yucho_account_application_rejected, UserMailer #=> その申込が拒否された時送信
  define_mailer_task :yucho_account_application_accepted, UserMailer #=> その申込が承認された時送信（未使用）
  define_mailer_task :membership_application_created_at_free_user, UserMailer #=> アクティブなユーザによってMembershipApplicationが作成された時送信
  define_mailer_task :premium_registration_with_yucho, UserMailer #=> 郵貯での一般会員登録申込が承認された時送信
  #ここまで

  define_mailer_task :hq_user_created, HqUserMailer

  define_mailer_task :bs_user_registered, BsUserMailer, HqUserMailer
  define_mailer_task :bs_app_form_accepted, UserMailer, HqUserMailer

  define_mailer_task :tutor_app_form_accepted, UserMailer, HqUserMailer
  define_mailer_task :tutor_created, TutorMailer, HqUserMailer
  define_mailer_task :tutor_become_regular, TutorMailer

  define_mailer_task :student_registration_form_created, UserMailer
  define_mailer_task :student_created, ParentMailer, StudentMailer, HqUserMailer, BsUserMailer
  define_mailer_task :student_trial_created, ParentMailer, StudentMailer, HqUserMailer, BsUserMailer
  define_mailer_task :student_updated, HqUserMailer, BsUserMailer
  define_mailer_task :student_no_bs_found, HqUserMailer
  define_mailer_task :student_organization_changed, HqUserMailer

  define_mailer_task :parent_registration_form_created, UserMailer
  define_mailer_task :parent_created, UserMailer, HqUserMailer
  #無料会員生成時
  define_mailer_task :parent_trial_created, UserMailer, HqUserMailer
  define_mailer_task :parent_updated, HqUserMailer, BsUserMailer

  define_mailer_task :lesson_schedule_change_requested, TutorMailer, StudentMailer
  define_mailer_task :lesson_invitation_rejected, StudentMailer
  define_mailer_task :lesson_started, ParentMailer
  define_mailer_task :lesson_ended, ParentMailer
  define_mailer_task :cs_report_not_written, StudentMailer, ParentMailer
  define_mailer_task :basic_lesson_info_accepted, OrganizationMailer, TutorMailer
  define_mailer_task :basic_lesson_info_rejected, OrganizationMailer, TutorMailer

  define_mailer_task :charge_limit_approaching, StudentMailer, ParentMailer
  define_mailer_task :charge_limit_reached, StudentMailer, ParentMailer


  private

    # チューターがレッスンをキャンセルしたことを通知する
    # すでにキャンセルをした受講者には何も通知しない
    def tutor_lesson_cancelled(tutor_lesson_cancellation)
      lesson = tutor_lesson_cancellation.lesson
      lesson.active_students.each do |student|
        StudentMailer.tutor_lesson_cancelled(student, tutor_lesson_cancellation).deliver
        coach = student.coach
        if coach.present?
          BsUserMailer.tutor_lesson_cancelled(student.coach, student, tutor_lesson_cancellation).deliver
          unless coach.bs_owner?
            bs_owner = coach.bs_owner
            if bs_owner.present?
              BsUserMailer.tutor_lesson_cancelled(bs_owner, student, tutor_lesson_cancellation).deliver
            end
          end
        end
      end
      TutorMailer.did_cancel_lesson(tutor_lesson_cancellation).deliver
    end
end