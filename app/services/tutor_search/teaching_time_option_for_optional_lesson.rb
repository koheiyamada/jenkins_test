class TutorSearch
  class TeachingTimeOptionForOptionalLesson

    class TimeRange
      def initialize(from, to)
        @from = from
        @to = to
      end

      attr_reader :from, :to
    end

    def initialize(params)
      @start_time = make_time(params[:start_time])
      @end_time = make_time(params[:end_time])
      if params[:dates].present?
        @dates = params[:dates].map{|date_attr| make_date(date_attr)}
        @and_or = params[:and_or] || 'or'
        @time_ranges = make_time_ranges
      end
    end

    attr_reader :time_ranges, :start_time, :end_time, :dates, :and_or

    def valid?
      dates.present?
    end

    def tutor_ids
      @tutor_ids ||= collect_tutor_ids
    end

    private

      # 日付・時刻が指定されていれば、該当するチューターのID一覧を返す。
      # 日付が指定されていなければnilを返す。
      def collect_tutor_ids
        if dates
          if time_ranges.present?
            tutor_ids_of_time_ranges(time_ranges)
          else
            tutor_ids_of_days(dates)
          end
        end
      end

      def make_time_ranges
        dates.map{|date| make_time_range(date)}.compact
      end

      def make_time_range(date)
        from = start_time ? date.to_time.change(hour: start_time.hour, min: start_time.min) : nil
        to   = end_time ? date.to_time.change(hour: end_time.hour, min: end_time.min) : nil
        if from && to && from > to
          to = 1.day.since(to)
        end
        (from || to) ? TimeRange.new(from, to) : nil
      end

      def make_date(date_attr)
        DateUtils.parse date_attr
      end

      def make_time(params)
        if params && params[:hour].present? && params[:minute].present?
          hour = params[:hour].to_i
          minute = params[:minute].to_i
          Time.current.change(hour: hour, min: minute)
        end
      end

      def tutor_ids_of_time_ranges(time_ranges)
        if and_or == 'or'
          tutor_ids_for_any_of_time_ranges(time_ranges)
        else
          tutor_ids_for_all_of_time_ranges(time_ranges)
        end
      end

      def tutor_ids_of_time_range(time_range)
        available_times = TutorDailyAvailableTime.containing(time_range.from, time_range.to).of_active_tutors
        available_times.pluck(:tutor_id).uniq
      end

      def tutor_ids_for_any_of_time_ranges(time_ranges)
        available_times = TutorDailyAvailableTime.containing_ranges(time_ranges).of_active_tutors
        available_times.pluck(:tutor_id).uniq
      end

      def tutor_ids_for_all_of_time_ranges(time_ranges)
        time_ranges.map{|time_range| tutor_ids_of_time_range(time_range)}.reduce{|result, ids| result & ids}
      end

      def tutor_ids_of_days(days)
        if and_or == 'or'
          tutor_ids_for_any_of_days(days)
        else
          tutor_ids_for_all_of_days(days)
        end
      end

      def tutor_ids_of_day(day)
        available_times = TutorDailyAvailableTime.of_day(day).of_active_tutors
        available_times.pluck(:tutor_id).uniq
      end

      def tutor_ids_for_any_of_days(days)
        available_times = TutorDailyAvailableTime.of_days(days).of_active_tutors
        available_times.pluck(:tutor_id).uniq
      end

      def tutor_ids_for_all_of_days(days)
        days.map{|day| tutor_ids_of_day(day)}.reduce{|result, ids| result & ids}
      end
  end
end