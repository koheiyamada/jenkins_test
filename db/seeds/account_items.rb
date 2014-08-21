if AccountItem.count == 0
  account_items = YAML.load_file(Rails.root.join('db/data/account_items.yml'))
  account_items.each do |name, item_info|
    AccountItem.create!(name:name)
  end
end