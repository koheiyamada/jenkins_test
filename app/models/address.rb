class Address < ActiveRecord::Base

  class << self
    def new_dummy
      new postal_code1:'111', postal_code2: '1111', line1: 'Kyoto', state: 'Kyoto'
    end
  end

  belongs_to :addressable, :polymorphic => true
  attr_accessible :postal_code, :postal_code1, :postal_code2, :line1, :line2, :state

  validates_presence_of :state, :line1
  validates_format_of :postal_code1, with: /\A[0-9]+\Z/, :allow_blank => true
  validates_format_of :postal_code2, with: /\A[0-9]+\Z/, :allow_blank => true
  validate :ensure_postal_code_parts_are_empty_or_filled

  before_validation :normalize
  before_validation do
    if address.blank? && line1.present?
      self.address = line1
    end
  end

  after_update do
    if postal_code_changed?
      if addressable.respond_to?(:on_address_changed)
        addressable.on_address_changed(self)
      end
    end
  end

  def serialize
    I18n.t('common.address_format2', postal_code:postal_code, state:state, line1:line1, line2:line2)
  end

  def area_code
    @area_code ||= lookup_area_code
  end

  def postal_data
    @postal_data ||= PostalCode.search_by_postal_code postal_code
  end

  # postal_code1とpostal_code2が与えられていれば、それらをハイフンで連結した値を返す。
  # それ以外の場合はnilを返す。
  def make_postal_code
    if postal_code1.present? && postal_code2.present?
      "#{postal_code1}-#{postal_code2}"
    end
  end

  def empty?
    postal_code1.blank? && postal_code2.blank? && state.blank? && line1.blank? && line2.blank?
  end

  private

    def lookup_area_code
      code = PostalCode.search_by_postal_code(postal_code)
      code.present? ? code.area_code.code : nil
    end

    def normalize
      self.postal_code = make_postal_code
      true
    end

    def ensure_postal_code_parts_are_empty_or_filled
      unless (postal_code1.present? && postal_code2.present?) || (postal_code1.blank? && postal_code2.blank?)
        errors.add :postal_code, :must_be_filled_or_empty
      end
    end
end
