year = ARGV[0].to_i
month = ARGV[1].to_i

puts "#{year},#{month}"

SobaChargeService.print_account_for_license_fee year, month