#RateSettings.delete_all
if RateSettings.count == 0
  YAML.load_file(Rails.root.join('db/data/rate_settings.yml')).each do |name, rate|
    RateSettings.create!(name:name, rate:rate)
  end
end
