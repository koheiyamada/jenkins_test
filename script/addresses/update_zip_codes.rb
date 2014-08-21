# coding: utf-8

=begin
新たに追加された郵便番号だけを追加する
=end

require 'set'
require 'csv'

db_codes = Set.new ZipCode.scoped.pluck(:code).map{|code| code.sub('-', '')}
codes = Set.new

CSV.foreach(ARGV[0]) do |row|
  codes.add row[0]
end

new_codes = codes - db_codes

ZipCode.transaction do
  new_codes.each do |code|
    zip_code = ZipCode.create!(code: ZipCode.normalize(code))
    puts zip_code.code
  end
end
