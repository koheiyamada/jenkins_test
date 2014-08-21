class Subject < ActiveRecord::Base
  attr_accessible :name
  attr_accessor :selected

  has_many :lessons
  has_and_belongs_to_many :tutors
  has_many :levels, class_name: SubjectLevel.name
  belongs_to :grade_group

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :grade_group_id

  def has_future_lessons?
    lessons.future.any?
  end

  def selected?
    selected
  end
end
