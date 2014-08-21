if Bank.count == 0
  YAML.load_file(Rails.root.join('db', 'data', 'banks.yml')).each do |attr|
    Bank.create! attr
  end
end
