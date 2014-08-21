class Exam < ActiveRecord::Base
  class << self
    def of_month(d)
      where(month: d.beginning_of_month .. d.end_of_month).first
    end

    def for_grade(grade)
      where(grade_id:grade.id)
    end

    def of_subject(s)
      if s.is_a?(Subject)
        where(subject_id:s.id)
      else
        where(subject_id:s.to_i)
      end
    end
  end

  mount_uploader :file, QuestionSheetUploader

  belongs_to :creator, class_name:User.name
  belongs_to :grade
  belongs_to :subject
  has_many :question_sheets
  attr_accessible :month, :subject, :grade, :creator, :file, :duration

  validates_presence_of :creator, :grade, :subject, :duration
  validates_numericality_of :duration, :only_integer => true, :greater_than => 0

  before_create do
    if month
      if beginning_of_term.blank?
        self.beginning_of_term = month.beginning_of_month
      end
      if end_of_term.blank?
        self.end_of_term = month.end_of_month
      end
    end
  end

  scope :of_this_year, lambda{where(month: Date.today.beginning_of_year .. Date.today.end_of_year).order("month")}

  def year
    month.year
  end

  def in_period?
    t = Time.now
    beginning_of_term && end_of_term && (t >= beginning_of_term) && (t <= end_of_term)
  end

  def have_period?
    beginning_of_term && end_of_term
  end

  def available?
    (!have_period?) || in_period?
  end
end
