class DateUtils
  class << self
    # Return the list of days of the month
    def days_of_month(date)
      date = date.to_date unless date.is_a?(Date)
      (date.beginning_of_month .. date.end_of_month).to_a
    end

    # Returns the first date of the next month
    def next_month
      1.month.since(Date.today).beginning_of_month
    end

    def next_month_of(t)
      1.month.since(t.to_date).beginning_of_month
    end

    def n_months_later(n)
      n.months.since(Date.today).beginning_of_month
    end

    def this_month
      Date.today.beginning_of_month
    end

    def parse(s)
      Date.parse(s)
    rescue
      nil
    end

    def period_of_settlement_month(year, month)
      d = Date.new(year, month)
      from = d.prev_month.change(day:SystemSettings.cutoff_date + 1)
      to = d.change(day:SystemSettings.cutoff_date)
      from .. to
    end

    def cutoff_date_of_month(time)
      time.change(day: SystemSettings.cutoff_date).to_date
    end

    def cutoff_datetime_of_month(time)
      time.change(day: SystemSettings.cutoff_date + 1).beginning_of_day
    end

    def next_cutoff_datetime(time)
      if time.day <= SystemSettings.cutoff_date
        cutoff_datetime_of_month(time)
      else
        cutoff_datetime_of_month(time.next_month)
      end
    end

    def prev_cutoff_datetime(time)
      if time.day <= SystemSettings.cutoff_date
        cutoff_datetime_of_month(time.prev_month)
      else
        cutoff_datetime_of_month(time)
      end
    end

    def aid_month_of_day(date)
      if date.day <= SystemSettings.cutoff_date
        Date.new(date.year, date.month)
      else
        Date.new(date.year, date.month).next_month
      end
    end
  end
end
