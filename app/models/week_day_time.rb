# coding:utf-8

class WeekDayTime
  class << self
    def day_of_wday(wday)
      date_table[wday.to_i]
    end

    def date_table
      @table ||= make_table(2000, 1)
    end

    def make_table(year, month)
      d1 = Date.new(year, month)
      (d1 .. 6.days.since(d1)).each_with_object({}) do |d, obj|
        obj[d.wday] = d
      end
    end

    # 曜日と時間データから、曜日を表すための時間データを作成して返す
    def from_wday_and_time(wday, time)
      d = day_of_wday(wday)
      Time.zone.local(d.year, d.month, d.day, time.hour, time.min, time.sec)
    end
  end

  def initialize(params)
    @t = WeekDayTime.from_wday_and_time(params[:wday], params[:time])
  end

  def to_time
    @t
  end

  def to_datetime
    @t.to_datetime
  end

  private
  def first_day_of_wday(year, month, wday)
    d1 = Date.new(year, month)
    (d1 .. 6.days.since(d1)).to_a.find{|d| d.wday == wday}
  end
end