if ARGV.size == 0
  exit 'specify file name'
end

require 'csv'
CSV.foreach(ARGV[0]) do |row|
  postal_code, prefecture, city, town, area_code = row
  if postal_code && prefecture && city && town && area_code
    postal_code = "%07d" % postal_code.delete('-').to_i
    code = PostalCode.find_by_postal_code(postal_code)
    if code.nil?
      PostalCode.create! do |code|
        code.postal_code = postal_code
        code.prefecture = prefecture
        code.city = city
        code.town = town
        code.area_code = area_code
      end
      puts "Added #{postal_code}"
    elsif code.postal_code != postal_code
      puts "Skipped #{postal_code}"
    end
  end
end
