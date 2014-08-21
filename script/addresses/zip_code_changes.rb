# coding: utf-8

=begin
データベースにある郵便番号とaddresses.csvにある郵便番号の違いを出力する。
=end

require 'set'
require 'csv'

db_codes = Set.new ZipCode.scoped.pluck(:code).map{|code| code.sub('-', '')}
codes = Set.new

CSV.foreach(ARGV[0]) do |row|
  codes.add row[0]
end

puts '# ONLY IN DB'
(db_codes - codes).each do |code|
  puts code
end

puts '# ONLY in addresses.csv'
(codes - db_codes).each do |code|
  puts code
end
