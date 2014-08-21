module MonthlyStatementsHelper
  def monthly_statement_title(monthly_statement)
    t('titles.monthly_statement', month:l(monthly_statement.date, :format => :month_year))
  end

  def monthly_statement_first_day(monthly_statement, format = :month_day2)
    day = monthly_statement.date.prev_month.change(day: SystemSettings.cutoff_date + 1)
    l(day, format: format)
  end

  def monthly_statement_last_day(monthly_statement, format = :month_day2)
    day = monthly_statement.date.change(day: SystemSettings.cutoff_date)
    l(day, format: format)
  end
end