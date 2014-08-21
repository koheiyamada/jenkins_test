class AreaCode < ActiveRecord::Base
  class << self
    def all_codes
      all.map(&:code).sort
    end
  end

  attr_accessible :code

  has_many :postal_codes

  validates_presence_of :code
  validates_uniqueness_of :code

  before_destroy :no_related_postal_codes?

  def to_s
    code
  end

  private

    def no_related_postal_codes?
      postal_codes.empty?
    end
end
