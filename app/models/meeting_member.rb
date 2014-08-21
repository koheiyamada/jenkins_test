# coding:utf-8

class MeetingMember < ActiveRecord::Base
  scope :done, joins(:meeting).where(meetings: {status: 'done'})
  scope :prefer_other_schedule, where(prefers_other_schedule: true)

  belongs_to :meeting
  belongs_to :user
  belongs_to :preferred_schedule, class_name: MeetingSchedule.name
  attr_accessible :user

  validate :preferred_schedule_belongs_to_meeting, if: 'preferred_schedule_id.present?'

  def member_id
    user.id
  end

  def select_schedule(schedule)
    unless schedule_selected?
      self.preferred_schedule = schedule
      if save
        Mailer.send_mail :meeting_schedule_selected, self, schedule
      end
    end
    self
  end

  # 選択肢に好ましい日時が無かった場合に呼ぶ
  def select_other_schedule
    unless schedule_selected?
      update_attribute :prefers_other_schedule, true
    end
  end

  def schedule_selected?
    prefers_other_schedule? || preferred_schedule_id.present?
  end

  def join
    if joined_at.blank?
      update_attribute :joined_at, Time.current
    else
      false
    end
  end

  def joined?
    joined_at.present?
  end

  private

    def preferred_schedule_belongs_to_meeting
      unless meeting.schedules.include? preferred_schedule
        errors.add :preferred_schedule_id, :not_meeting_schedule
      end
    end
end
