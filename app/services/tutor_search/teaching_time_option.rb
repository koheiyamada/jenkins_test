class TutorSearch
  class TeachingTimeOption
    def initialize(params)
      if params[:wdays]
        @wdays = params[:wdays].keys.map(&:to_i)
        @start_time = make_time(params[:start_time])
        @end_time = make_time(params[:end_time])
        @time_ranges = @wdays.map{|wday| make_wday_range(wday, @start_time, @end_time)}.compact
      end
    end

    attr_reader :time_ranges, :start_time, :end_time, :wdays

    def valid?
      time_ranges.present?
    end

    def tutor_ids
      @tutor_ids ||= tutor_ids_of_time_ranges(time_ranges)
    end

    private

      def make_time(params)
        if params[:hour].present? && params[:minute].present?
          hour = params[:hour].to_i
          minute = params[:minute].to_i
          Time.current.change(hour: hour, min: minute)
        end
      end

      def make_wday_range(wday, t1, t2)
        wt1 = t1 ? WeekDayTime.new(wday: wday, time: t1) : nil
        wt2 = t2 ? WeekDayTime.new(wday: wday, time: t2) : nil
        if wt1 && wt2
          WeekdayTimeRange.new(start_time: wt1.to_time, end_time: wt2.to_time)
        elsif wt1 && wt2.blank?
          t1 = wt1.to_time
          t2 = Lesson.duration_per_unit.since(t1)
          WeekdayTimeRange.new(start_time: t1, end_time: t2)
        elsif wt1.blank? && wt2
          t2 = wt2.to_time
          t1 = Lesson.duration_per_unit.ago(t2)
          WeekdayTimeRange.new(start_time: t1, end_time: t2)
        else
          nil
        end
      end

      def tutor_ids_of_time_ranges(weekday_time_ranges)
        weekday_schedules = WeekdaySchedule.contains_ranges(weekday_time_ranges).joins(:tutor).where(users: {status: 'active'})
        weekday_schedules.pluck(:tutor_id).uniq
      end
  end
end