# coding:utf-8

require 'csv'

BATCH_SIZE = 1000

def populate_postal_code(file)
  PostalCode.transaction do
    puts '... Deleting current data'
    PostalCode.delete_all
    puts '... Deleted'

    postal_codes = []
    count = 0
    CSV.foreach(file) do |row|
      postal_code = PostalCode.new do |c|
        c.prefecture  = row[1]
        c.city        = row[2]
        c.town        = row[3]
        #c.area_code   = row[4]
        c.zip_code    = ZipCode.find_by_code(ZipCode.normalize(row[0]))
        # 複数のエリアコードがありうる場合にも一旦最初のもので初期化する。
        # 修正は別途 area_code_select.rb で指定する。
        c.area_code   = AreaCode.find_by_code(row[4])
      end
      if postal_code.valid?
        postal_codes << postal_code
      else
        puts postal_code.errors.full_messages
      end
      if postal_codes.size >= BATCH_SIZE
        result = PostalCode.import(postal_codes)
        postal_codes = []
        count += 1
        puts "..imported #{count * BATCH_SIZE}"
      end
    end
    PostalCode.import postal_codes
    puts "... #{PostalCode.count} postal codes imported."
  end
end

if $0 == __FILE__
  populate_postal_code ARGV[0]
end
