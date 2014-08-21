class BasicLessonWeekdaySchedule < ActiveRecord::Base
  include Aid::TimeRange

  class << self
    def of_tutor(tutor)
      includes(:basic_lesson_info)
      .where(basic_lesson_infos: {tutor_id: tutor.id, status: BasicLessonInfo.fixed_statuses})
    end

    def conflict_with(other, tolerance=0)
      t1 = tolerance.minutes.ago(other.start_time)
      t2 = tolerance.minutes.since(other.end_time)
      where('start_time < :end_time AND end_time > :start_time', start_time:t1, end_time:t2)
    end

    def except_for(id)
      where("basic_lesson_weekday_schedules.id != ?", id)
    end
  end

  belongs_to :basic_lesson_info
  attr_accessible :end_time, :start_time, :units, :wday
  attr_writer :wday

  validates_associated :basic_lesson_info
  validates_presence_of :start_time, :units
  validate do
    if start_time && start_time.year > 2000
      errors.add(:start_time, I18n.t("common.error"))
    end
  end

  before_validation do
    normalize
  end

  before_save do
    self.end_time = Lesson.end_time(start_time, units)
  end

  def wday
    @wday ||= start_time && start_time.wday
  end

  def wday=(val)
    attribute_will_change!(:wday) if wday != val.to_i
    @wday = val.to_i
  end

  def hour
    start_time.hour
  end

  def min
    start_time.min
  end

  def description
    I18n.t('date.abbr_day_names')[wday] + I18n.l(start_time, :format => :only_time) + "-" + I18n.l(end_time, :format => :only_time)
  end

  #def conflict?(schedule)
  #  wday == schedule.wday && start_time < schedule.end_time && end_time > schedule.start_time
  #end

  def conflict_with_lesson?(lesson, tolerance=0)
    range = lesson.weekday_time_range
    conflict?(range, tolerance)
  end

  #############################################################
  # 設定変更
  #############################################################
  def change_time!(wday, units, time)
    self.wday = wday
    self.units = units
    if time.is_a?(Hash)
      # hour, min
      self.start_time = Time.new(start_time.year, start_time.month, start_time.day, time[:hour].to_i, time[:min].to_i)
    else
      # Time or DateTime
      self.start_time = time
    end
    save!
    if basic_lesson_info.present?
      basic_lesson_info.on_schedule_changed(self)
    end
  end

  private

    def normalize
      if start_time
        if wday
          if start_time.year > 2000 || wday != start_time.wday
            self.start_time = WeekDayTime.new(wday:wday, time:start_time).to_time
          end
        else
          self.wday = start_time.wday
        end
      end
      if start_time && units
        self.end_time = Lesson.end_time(start_time, units)
      end
    end
end
