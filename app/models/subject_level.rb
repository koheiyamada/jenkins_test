class SubjectLevel < ActiveRecord::Base
  belongs_to :subject
  has_many :teaching_subjects, :dependent => :destroy
  attr_accessible :code, :level

  validates_presence_of :subject_id, :code, :level
  validates_uniqueness_of :level, scope: :subject_id
  validates_uniqueness_of :code, scope: :subject_id

  def name
    I18n.t("subject_level.codes.#{code}")
  end
end
