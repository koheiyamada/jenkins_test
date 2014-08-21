class StudentSettings < ActiveRecord::Base
  belongs_to :student
  attr_accessible :max_charge

  validates_numericality_of :max_charge, :only_integer => true, :greater_than_or_equal_to => 1000

  before_validation :set_initial_values, :on => :create

  private

    def set_initial_values
      self.max_charge = SystemSettings.instance.default_max_charge
    end
end
