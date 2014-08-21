module Aid
  module TimeRange
    # time range must have start_time and end_time

    # otherの時間範囲を内包する場合はtrue
    def include?(other)
      start_time.wday == other.start_time.wday && start_time <= other.start_time && end_time >= other.end_time
    end

    # otherの時間範囲と一部でも重なる場合はtrue
    def conflict?(other, tolerance=0)
      t1 = tolerance.minutes.ago(start_time)
      t2 = tolerance.minutes.since(end_time)
      if other.is_a?(Range)
        t1 < other.last && t2 > other.first
      else
        t1 < other.end_time && t2 > other.start_time
      end
    end

    def time_range_string(format_type = nil)
      case format_type
      when :only_time
        "#{I18n.l(start_time, format: :only_time2)}-#{I18n.l(end_time, format: :only_time2)}"
      when :wday
        "#{I18n.l(start_time.to_date, format: :only_wday)} #{I18n.l(start_time, format: :only_time2)}-#{I18n.l(end_time, format: :only_time2)}"
      else
        "#{I18n.l(start_time.to_date, format: :month_day2)} #{I18n.l(start_time, format: :only_time2)}-#{I18n.l(end_time, format: :only_time2)}"
      end
    end
  end
end