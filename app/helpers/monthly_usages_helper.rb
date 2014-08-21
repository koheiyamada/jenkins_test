module MonthlyUsagesHelper
  def monthly_usage_period(monthly_usage)
    period = DateUtils.period_of_settlement_month(monthly_usage.year, monthly_usage.month)
    t('titles.monthly_usage_between',
      from: l(period.first, format: :month_day2),
      to:   l(period.last, format: :month_day2))
  end
end