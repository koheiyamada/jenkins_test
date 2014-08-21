# coding:utf-8

=begin
複数のエリアコードが関連付けられている郵便番号の住所に対して、
対話的にエリアコードを選択してデータベースに反映するプログラム
=end

require 'csv'

LINE_FEED = "\n"

POSTAL_CODE_COLUMN = 1
AREA_CODE_COLUMN   = 0


def postal_code?(s)
  /\A\d{3}-\d{4}/ =~ s
end

def area_code?(s)
  /\A\d{3}-\d{3}/ =~ s
end

def record?(row)
  row.size >= 5 && area_code?(row[AREA_CODE_COLUMN]) && postal_code?(row[POSTAL_CODE_COLUMN])
end

def print_data(data)
  data.each do |postal_code, area_codes|
    puts "#{postal_code},#{area_codes.join(',')}"
  end
end

def load_aid_ken_all(path)
  content = File.read(path)
  lines = content.split(LINE_FEED)
  lines.each_with_object({}) do |line, obj|
    row = line.split(',')
    if record?(row)
      postal_code, area_code = row[1], row[0]
      postal_code = '%07d' % postal_code.delete('-').to_i
      if obj.has_key?(postal_code)
        obj[postal_code] << {address: "#{postal_code} #{row[2]} #{row[3]} #{row[4]}", area_code: area_code}
      else
        obj[postal_code] = [{address: "#{postal_code} #{row[2]} #{row[3]} #{row[4]}", area_code: area_code}]
      end
    end
  end
end

def make_area_code_mappings(aid_ken_all)
  aid_ken_all.each_with_object({}) do |(postal_code, addresses), data|
    data[postal_code] = addresses.map{|address| address[:area_code]}.uniq
  end
end

def ask_user(postal_code, addresses)
  puts ">> #{postal_code.postal_code} #{postal_code.prefecture} #{postal_code.city} #{postal_code.town}"
  addresses.each_with_index do |r, i|
    puts '%d: %s, %s' % [i + 1, r[:address], r[:area_code]]
  end
  print '? '
  s = STDIN.gets
  n = s.to_i
  if n > 0 && n <= addresses.size
    addresses[n - 1][:area_code]
  else
    ask_user(postal_code, addresses)
  end
end

def main(aid_ken_all, area_code_mappings)
  updated_records = []
  PostalCode.transaction do
    mappings = area_code_mappings.select{|postal_code, area_codes| area_codes.size > 1}
    mappings.keys.each do |key|
      z = ZipCode.of_code key
      z.postal_codes.each do |postal_code|
        code = ask_user(postal_code, aid_ken_all[key])
        puts "... #{code} selected."
        postal_code.area_code = AreaCode.find_by_code(code)
        postal_code.save!
        updated_records << postal_code
      end
    end
  end
  puts '#################### Updated records #####################'
  updated_records.each do |c|
    puts "- #{c.postal_code} #{c.prefecture} #{c.city} #{c.town}: #{c.area_code}"
  end
end

if $0 == __FILE__
  aid_ken_all = load_aid_ken_all ARGV[0]
  area_code_mappings = make_area_code_mappings(aid_ken_all)
  main aid_ken_all, area_code_mappings
end
