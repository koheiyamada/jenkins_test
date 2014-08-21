table = YAML.load_file(Rails.root.join('db/data/charge_settings.yml'))
table.each do |name, amount|
  charge_settings = ChargeSettings.find_by_name name
  if charge_settings.blank?
    ChargeSettings.create name:name, amount:amount
  else
    charge_settings.update_attribute :amount, amount
  end
end
