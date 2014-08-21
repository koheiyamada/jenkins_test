# encoding:utf-8

# グローバル設定
if SystemSettings.count == 0
  SystemSettings.create! do |settings|
    settings.entry_fee = 20000
    settings.message_storage_period = 30 # days
    settings.bs_share_of_lesson_sales = 0.25
    settings.cutoff_date = 20
    settings.tutor_share_of_lesson_fee = 0.57
    settings.calculation_date = 26
    settings.default_max_charge = 50000
    settings.tax_rate = 0.05
  end
end
