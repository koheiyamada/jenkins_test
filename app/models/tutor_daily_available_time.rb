class TutorDailyAvailableTime < ActiveRecord::Base

  class << self
    def overlap_with(start_time, end_time)
      where('start_at < :end_time AND end_at > :start_time', start_time: start_time, end_time: end_time)
    end

    def containing(start_time, end_time)
      where('start_at <= :start_time AND :end_time <= end_at', start_time: start_time, end_time: end_time)
    end

    def of_times(*times)
      # '(start_at <= :t0 AND :t0 <= end_at) OR (start_at <= :t1 AND :t1 <= end_at) OR ...', t0: times[0], ...
      q = (0...times.size).map{|i| "(start_at <= :t#{i} AND :t#{i} <= end_at)"}.join(' OR ')
      options = {}
      times.each_with_index do |t, i|
        options["t#{i}".to_sym] = t
      end
      where(q, options)
    end

    def containing_ranges(time_ranges, conjunction='or')
      condition = time_ranges.map {|time_range|
        time_range.to.present? ? '(start_at <= ? AND ? <= end_at)' : '(start_at <= ?)'
      }.join(" #{conjunction} ")
      logger.debug "CONDITION=#{condition}"
      params = time_ranges.flat_map{|r|
        r.to.present? ? [r.from, r.to] : [r.from]
      }
      where(condition, *params)
    end

    def of_active_tutors
      joins(:tutor).where(users: {status: 'active'})
    end

    def of_days(days, conjunction='or')
      condition = (['(? <= start_at AND start_at <= ?)'] * days.size).join(" #{conjunction} ")
      logger.debug "CONDITION=#{condition}"
      params = days.flat_map{|date| [date.beginning_of_day, date.end_of_day]}
      where(condition, *params)
    end

    def of_day(date)
      where('start_at < :to AND end_at > :from', from: date.beginning_of_day, to: date.end_of_day)
    end

    def of_month(date)
      t = date.to_time
      where('start_at < :to AND end_at > :from', from: t.beginning_of_month, to: t.end_of_month)
    end

    def from_today
      where('start_at >= ?', Date.today.beginning_of_day)
    end

    def for_calendar
      from_today.until(3.months.from_now)
    end

    def until(date_or_time)
      where('start_at <= ?', date_or_time.end_of_day)
    end

    def to_model_attributes(js_attributes)
      {
        start_at: Time.at(js_attributes[:start_at].to_i / 1000),
        end_at: Time.at(js_attributes[:end_at].to_i / 1000)
      }
    end
  end

  belongs_to :tutor, counter_cache: :daily_available_times_count

  attr_accessible :end_at, :start_at

  validates_presence_of :end_at, :start_at
  validate :ensure_minimum_time_range
  validate :ensure_schedules_not_overlapped

  def overlapping_available_times
    if new_record?
      tutor.daily_available_times.overlap_with(start_at, end_at)
    else
      tutor.daily_available_times.overlap_with(start_at, end_at).where('id != ?', id)
    end
  end

  def time_range
    start_at .. end_at
  end

  def as_json(options=nil)
    super(options).merge('start_at' => start_at.to_i * 1000, 'end_at' => end_at.to_i * 1000)
  end

  def to_date
    start_at.to_date
  end

  def to_dates
    # 翌日の0時0分が終了時刻の場合は翌日を含めない。
    [start_at.to_date, 1.second.ago(end_at).to_date].uniq
  end

  def include?(time)
    start_at <= time && time <= end_time
  end

  def include_range?(from, to)
    start_at <= from && to <= end_at
  end

  def connected?(other)
    end_at == other.start_at || start_at == other.end_at
  end

  private

    def ensure_minimum_time_range
      if end_at < LessonSettings.minimum_time_range.minutes.since(start_at)
        errors.add :end_at, :must_be_at_least_after_60_minutes
      end
    end

    def ensure_schedules_not_overlapped
      if overlapping_available_times.present?
        errors.add :time_range, :must_not_be_overlap_with_other_available_times
      end
    end
end
