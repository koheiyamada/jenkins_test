class PostalCode < ActiveRecord::Base
  attr_accessible :area_code, :city, :prefecture, :town

  class << self
    def search_by_postal_code(code)
      code = ZipCode.normalize(code)
      find_by_postal_code(code)
    end

    def find_by_postal_code(code)
      joins(:zip_code).where(zip_codes: {code: code}).first
    end

    # 与えられた郵便番号に対応するエリアコードを返す
    def area_code_of_postal_code(code)
      if code
        code = ZipCode.normalize(code)
        postal_code = find_by_postal_code(code)
        if postal_code
          postal_code.area_code.code
        end
      end
    end

    def area_codes
      AreaCode.all_codes
    end
  end

  belongs_to :area_code
  belongs_to :zip_code, counter_cache: :area_codes_count

  validates_presence_of :area_code_id, :zip_code_id
  validates_uniqueness_of :town, scope: [:city, :prefecture, :zip_code_id]

  before_validation do
    normalize
  end

  def line1
    city + town
  end

  def of_address?(address)
    postal_code == normalize_postal_code(address.postal_code)
  end

  def postal_code
    zip_code.to_s
  end

  delegate :code1, :code2, to: :zip_code

  private

    def normalize
      self.town = '' if town.nil?
    end

    def normalize_postal_code(postal_code_string)
      postal_code_string.gsub('-', '')
    end
end
