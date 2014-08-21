# coding:utf-8

require 'csv'

BATCH_SIZE = 1000

def populate_postal_code(file)
  PostalCode.transaction do
    count = 0
    CSV.foreach(file) do |row|
      zip_code   = ZipCode.find_by_code(ZipCode.normalize(row[0]))
      area_code  = AreaCode.find_by_code(row[4])
      prefecture = row[1]
      city       = row[2]
      town       = row[3] || ''


      # puts "? #{zip_code.code} #{prefecture} #{city} #{town} #{area_code.code}"
      postal_code = zip_code.postal_codes.where(prefecture: prefecture, city: city, town: town).first
      if postal_code.present?
        if postal_code.area_code != area_code
          # エリアコードが変わった
          if postal_code.update_attribute :area_code, area_code
            puts "Area code changed for #{zip_code.code} #{prefecture} #{city} #{town} #{area_code.code}"
            puts "C #{zip_code.code} #{prefecture} #{city} #{town} #{area_code.code}"
          else
            puts postal_code.errors.full_messages
          end
        else
          # 変化なし
          # puts "- #{zip_code.code} #{prefecture} #{city} #{town} #{area_code.code}"
        end
      else
        # 新しい住所
        zip_code.postal_codes.create!(prefecture: prefecture, city: city, town: town, area_code: area_code)
        puts "A #{zip_code.code} #{prefecture} #{city} #{town} #{area_code.code}"
      end
      count += 1
      if count % 1000 == 0
        puts count
      end
    end
  end
end

if $0 == __FILE__
  populate_postal_code ARGV[0]
end
