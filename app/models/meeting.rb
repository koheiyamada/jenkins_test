# coding:utf-8
class Meeting < ActiveRecord::Base
  include JobOwner

  class << self
    def handle_skipped_meetings(date)
      held_on(date).not_done.each do |meeting|
        meeting.on_skipped
      end
    end

    def held_on(date)
      where(datetime: date.to_time.all_day)
    end

    def time_to_send_skipped_message
      Time.current.change(hour: 8, min: 0)
    end

    def for_list
      includes(:members)
    end
  end

  scope :registering, where(status: 'registering')
  scope :scheduled, where(status: 'scheduled')
  scope :scheduling, where(status: 'scheduling')
  scope :done, where(status: 'done')
  scope :not_done, where("status != 'done'")
  scope :today_or_later, lambda{where('datetime > ?', Time.current.beginning_of_day)}
  scope :current, lambda{where(datetime: Time.current.all_day).where('datetime < :now AND status != \'done\'', now: Time.current)}

  #
  # 検証
  #
  validate :has_more_than_one_members, if: :scheduling?
  validates_presence_of  :schedules, if: :scheduling?
  validates_inclusion_of :status, :in => %w(registering scheduling scheduled done)
  validates_presence_of :datetime, if: :scheduled?

  #
  # 派生処理
  #

  before_save :becomes_scheduled, if: 'schedule_id_changed? && schedule.present?'

  #
  # 関連・属性
  #
  belongs_to :creator, class_name: User.name
  has_many :meeting_members
  has_many :members, through: :meeting_members, source: :user, uniq: true, validate: false
  has_many :schedules, class_name: MeetingSchedule.name, validate: true
  belongs_to :schedule, class_name: MeetingSchedule.name
  has_one :meeting_report, :dependent => :destroy
  has_many :students, through: :meeting_members, conditions: {type: Student.name}, source: :user
  attr_accessible :datetime, :creator

  #
  # Instance methods
  #

  def registering?
    status == 'registering'
  end

  def scheduling?
    status == 'scheduling'
  end

  def scheduled?
    status == 'scheduled'
  end

  def done?
    status == 'done'
  end

  def have_enough_members?
    members.count > 1
  end

  def schedules_full?
    schedules.count >= 3
  end

  def today?
    datetime.present? && datetime.today?
  end

  # 登録を完了する。
  def finish_registering
    if registering?
      self.status = 'scheduling'
      if save
        notify_registered
      end
    end
    self
  end

  def close
    if scheduled?
      self.status = 'done'
      self.closed_at = Time.current
      save
    end
    self
  end

  # 日程を確定する
  def fix_schedule
    unless scheduled?
      self.status = 'scheduled'
      self.save
    end
    self
  end

  def member(user)
    meeting_members.find_by_user_id(user.id)
  end

  # 参加者に受講者がいればそれを返す。
  # いなければnilを返す。
  def student_member
    members.of_type(Student).first
  end

  def member?(user)
    members.include? user
  end

  def on_skipped
    if overdue?
      logger.info "Meeting #{id} was skipped"
      send_at Meeting.time_to_send_skipped_message, :send_skipped_message
    end
  end

  def overdue?
    datetime.present? && datetime < Time.current.beginning_of_day
  end

  def send_skipped_message
    members.each do |member|
      member.send_mail(:meeting_skipped, self)
    end
  end

  def host
    @host ||= members.where(type: [HqUser.name, BsUser.name]).first
  end

  def host_name
    host && host.full_name
  end

  def join(user)
    m = member(user)
    if m.present?
      m.join
    else
      false
    end
  end

  # 参加予定者が全員参加済みであればtrueを返す
  def held?
    meeting_members.all?{|m| m.joined?}
  end

  private

    #
    # 検証
    #

    def has_more_than_one_members
      if members.count < 2
        errors.add :members, :requires_more_than_one
      end
    end

    def has_schedules
      if schedules.empty?
        errors.add :schedules, :not_given
      end
    end

    def schedules_are_future
      if schedules.any?{|schedule| schedule.datetime < Time.current}
        errors.add :schedules, :not_future
      end
    end

    #
    # フック
    #

    def becomes_scheduled
      self.datetime = schedule.datetime
      self.status = 'scheduled'
    end

    def notify_registered
      Mailer.send_mail :meeting_registered, self
    end
end
