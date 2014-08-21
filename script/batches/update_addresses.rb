if ARGV.size == 0
  exit 'specify file name'
end

def find_postal_code(postal_codes, params)
  if postal_codes.empty?
    nil
  elsif postal_codes.size == 1
    postal_codes[0]
  else
    if params.empty?
      $stderr.puts "Failed to identify!"
    else
      k, v = params.first
      params.delete(k)
      postal_codes = postal_codes.select{|postal_code| postal_code.send(k) == v}
      find_postal_code(postal_codes, params)
    end
  end
end

require 'csv'
CSV.foreach(ARGV[0]) do |row|
  postal_code, area_code, prefecture, city, town = row
  if postal_code && prefecture && city && town && area_code
    postal_code = "%07d" % postal_code.delete('-').to_i
    postal_codes = PostalCode.where(postal_code:postal_code)
    code = find_postal_code(postal_codes, postal_code:postal_code, prefecture:prefecture, city:city, town:town)
    if code.nil?
      $stderr.puts "Not found for #{postal_code}"
    else
      if code.area_code != area_code
        puts "#{postal_code},#{code.area_code},#{area_code}"
      else
        #$stderr.puts "Not changed #{code}"
      end
    end
  else
    puts 'Invalid row'
  end
end
