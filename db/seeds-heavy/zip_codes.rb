# coding:utf-8

=begin
郵便番号データを登録する
=end

require 'csv'
require 'set'

BATCH_SIZE = 1000

def batch_create(file)
  zip_codes = Set.new
  CSV.foreach(file) do |row|
    zip_codes << row[0]
  end
  puts "... #{zip_codes.size} zip codes are found."

  batch = []
  batch_count = 0
  zip_codes.each do |code|
    batch << code
    if batch.size > BATCH_SIZE
      ZipCode.import batch.map{|code| ZipCode.new(code: ZipCode.normalize(code))}
      batch_count += 1
      puts "... imported #{batch_count * BATCH_SIZE}"
      batch = []
    end
  end
  ZipCode.import batch.map{|code| ZipCode.new(code: ZipCode.normalize(code))}
end

if ZipCode.count == 0
  file = Rails.root.join('db/data/postal_codes/addresses.csv')
  batch_create(file)
  puts "... #{ZipCode.count} zip codes imported."
end
