# coding:utf-8

=begin
エリアコードデータを登録する
=end

if AreaCode.count == 0
  require 'csv'
  require 'set'
  BATCH_SIZE = 1000
  file = Rails.root.join('db/data/postal_codes/addresses.csv')

  area_codes = []
  count = 0

  AreaCode.transaction do
    CSV.foreach(file) do |row|
      code = row[4]
      unless area_codes.include? code
        area_codes << code
      end
      if area_codes.size >= BATCH_SIZE
        AreaCode.import area_codes.map{|code| AreaCode.new(code: code)}
        count += area_codes.size
        area_codes.clear()
        puts "..imported #{count}"
      end
    end
    AreaCode.import area_codes.map{|code| AreaCode.new(code: code)}
  end
  puts "... #{AreaCode.count} area codes imported."
end
