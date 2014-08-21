# coding:utf-8
class StudentCoach < ActiveRecord::Base
  class << self
    def clear(user)
      destroy_all(student_id: user.id)
    end
  end

  belongs_to :coach, class_name: User.name
  belongs_to :student

  attr_accessible :student

  validates_uniqueness_of :student_id # 受講者にコーチは一人
end
