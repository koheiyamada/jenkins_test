class WeekdaySchedule < ActiveRecord::Base
  class << self
    def contains(time)
      where('start_time <= :t AND :t < end_time', t: time)
    end

    def contains_range(weekday_time_range)
      where('start_time <= :t1 AND :t2 <= end_time', t1: weekday_time_range.start_time, t2: weekday_time_range.end_time)
    end

    def contains_ranges(weekday_time_ranges)
      condition = (['(start_time <= ? AND ? <= end_time)'] * weekday_time_ranges.size).join(' OR ')
      logger.debug "CONDITION=#{condition}"
      params = weekday_time_ranges.flat_map{|r| [r.start_time, r.end_time]}
      where(condition, *params)
    end
  end

  include Aid::TimeRange
  belongs_to :tutor, :counter_cache => true
  attr_accessible :wday, :start_time, :end_time

  validates_presence_of :wday, :start_time, :end_time
  validate :time_range_does_not_overlap

  before_validation do
    normalize
  end

  after_create do
    update_tutor_index
  end

  after_destroy do
    update_tutor_index
  end

  def wday
    @wday ||= start_time && start_time.wday
  end

  def wday=(val)
    @wday = val
  end

  def hour
    start_time.hour
  end

  def minute
    start_time.min
  end

  def duration
    (end_time - start_time) / 60
  end

  def time_range
    start_time .. end_time
  end

  # この曜日＋時間帯のうちすでに授業が入っている時間帯のリストを返す
  # [[from1, to1], [from2, to2], ...]
  def reserved_time_ranges
    basic_lesson_infos = tutor.basic_lesson_infos.includes(:schedules).where("basic_lesson_weekday_schedules.start_time < :t1 AND basic_lesson_weekday_schedules.end_time > :t2", t1:end_time, t2:start_time)
    optional_lessons = optional_lessons_between(Date.today, 3.months.since(Date.today))
    {basic_lessons: basic_lesson_infos.map{|e| e.schedules.map{|s| [s.start_time, s.end_time]}}.flatten(1),
     optional_lessons:optional_lessons.map{|e| [e.start_time, e.end_time]}}
  end

  def optional_lessons_between(date_from, date_to)
    days = (date_from .. date_to).select{|d| d.wday == wday}
    args = []
    condition = days.map do |day|
      t1 = Time.zone.local(day.year, day.month, day.day, start_time.hour, start_time.min, start_time.sec)
      t2 = Time.zone.local(day.year, day.month, day.day, end_time.hour, end_time.min, end_time.sec)
      args << t1 << t2
      "(end_time > ? AND start_time < ?)"
    end.join(" OR ")
    tutor.optional_lessons.where(condition, *args)
  end

  #def include?(schedule)
  #  wday == schedule.wday && start_time <= schedule.start_time && end_time >= schedule.end_time
  #end

  def description
    I18n.t("date.abbr_day_names")[wday] + I18n.l(start_time, :format => :only_time) + "-" + I18n.l(end_time, :format => :only_time)
  end

  def include?(from, to)
    w = WeekdayTimeRange.new(wday:from.wday, hour:from.hour, min:from.min, duration:(to - from) / 60)
    start_time <= w.start_time && w.end_time <= end_time
  end

  def overlap?(other)
    start_time < other.end_time && end_time > other.start_time
  end

  def <=>(other)
    [wday, hour, minute] <=> [other.wday, other.hour, other.minute]
  end

  def to_s
    I18n.t('weekday_schedule.formats.default', wday: I18n.t('date.abbr_day_names')[wday],
                                               from: I18n.l(start_time, format: :only_time),
                                               to: I18n.l(end_time, format: :only_time))
  end

  private
    def normalize
      if wday && start_time && end_time
        self.start_time = WeekDayTime.from_wday_and_time wday, start_time
        self.end_time = WeekDayTime.from_wday_and_time wday, end_time
        w = WeekdayTimeRange.new(start_time: start_time, end_time: end_time)
        self.start_time = w.start_time
        self.end_time = w.end_time
      end
    end

    def time_range_does_not_overlap
      if tutor.present?
        tutor.weekday_schedules.each do |ws|
          if ws.overlap? self
            errors.add :time_range, :overlap_with, time_range: ws.to_s
          end
        end
      end
    end

    def update_tutor_index
      if tutor
        Sunspot.index! tutor
        logger.info 'TUTOR:REINDEX reason:weekday_schedule_added'
      end
    rescue => e
      logger.error e
    end
end
