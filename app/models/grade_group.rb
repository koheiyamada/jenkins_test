class GradeGroup < ActiveRecord::Base
  class << self
    def by_group_order
      order(:grade_group_order)
    end
  end

  has_many :grades, :foreign_key => :group_id, :order => :grade_order
  has_many :subjects

  attr_accessible :name
  validates_presence_of :name
  validates_uniqueness_of :name

  def level_names
    I18n.t('teaching_subjects.levels')[id]
  end
end
