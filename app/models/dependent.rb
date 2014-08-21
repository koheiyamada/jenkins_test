class Dependent < ActiveRecord::Base
  belongs_to :parent
  belongs_to :student

  attr_accessible :parent_id, :student_id
end
