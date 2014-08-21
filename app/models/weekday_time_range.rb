class WeekdayTimeRange
  def initialize(params)
    if [:start_time, :end_time].all?{|k| params[k]}
      init_with_times params[:start_time], params[:end_time]
    elsif [:wday, :hour, :min, :duration].all?{|k| params[k]}
      init_with_wday_and_time(params)
    else
      raise "invalid argument"
    end
  end

  attr_reader :start_time, :end_time

  def wday
    @start_time.wday
  end

  def duration
    @duration ||= (end_time - start_time) / 60
  end

  private

    def init_with_times(t1, t2)
      if t2 < t1
        t2 = 24.hours.since t2
      end
      init_with_wday_and_time(wday: t1.wday, hour: t1.hour, min: t1.min, duration: (t2 - t1) / 60)
    end

    def init_with_wday_and_time(params)
      d = WeekDayTime.day_of_wday(params[:wday])
      @start_time = Time.zone.local(d.year, d.month, d.day, params[:hour].to_i, params[:min].to_i)
      @end_time = params[:duration].to_i.minutes.since(@start_time)
    end
end