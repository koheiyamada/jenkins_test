# coding:utf-8

if PostalCode.count == 0
  require './script/addresses/update_addresses'
  data_file = Rails.root.join('db/data/postal_codes/addresses.csv')
  populate_postal_code data_file
end
