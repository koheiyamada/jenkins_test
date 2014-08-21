module TimesHelper
  def time_zone
    l Time.now, format: :time_zone2
  end
end