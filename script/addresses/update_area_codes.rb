# coding: utf-8

=begin
新たに追加された郵便番号だけを追加する
=end

require 'set'
require 'csv'

db_codes = Set.new AreaCode.scoped.pluck(:code)
codes = Set.new

CSV.foreach(ARGV[0]) do |row|
  codes.add row[4]
end

new_codes = codes - db_codes

AreaCode.transaction do
  new_codes.each do |code|
    area_code = AreaCode.create!(code: code)
    puts area_code.code
  end
end
