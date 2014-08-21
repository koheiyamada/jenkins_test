class ZipCode < ActiveRecord::Base

  class << self
    def normalize(code)
      if code.present?
        code = code.to_s
        case code
        when format
          code
        when /\A\d{1,7}\Z/
          insert_dash(pad_zeros(code))
        else
          nil
        end
      end
    end

    def of_code(code)
      find_by_code(normalize(code))
    end

    private

      def format
        @format ||= /\A\d{3}-\d{4}\Z/
      end

      def pad_zeros(s)
        if s.length < 7
          ('0' * (7 - s.length)) + s
        else
          s
        end
      end

      def insert_dash(s)
        if /\A\d{7}\Z/ =~ s
          s[0..2] + '-' + s[3..-1]
        else
          s
        end
      end
  end

  attr_accessible :code

  has_many :postal_codes
  has_many :area_codes, through: :postal_codes, uniq: true

  validates_format_of :code, with: /\A\d{3}-\d{4}\Z/
  validates_uniqueness_of :code

  before_validation :normalize
  before_destroy :no_related_postal_codes?

  def code1
    @code1 ||= code.split('-')[0]
  end

  def code2
    @code2 ||= code.split('-')[1]
  end

  def to_s
    code
  end

  private

    def no_related_postal_codes?
      postal_codes.empty?
    end

    def normalize
      if code.present?
        self.code = ZipCode.normalize(code)
      end
    end
end
