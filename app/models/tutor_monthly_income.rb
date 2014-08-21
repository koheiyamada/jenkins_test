class TutorMonthlyIncome < ActiveRecord::Base
  class << self
    def latest
      order('year DESC, month DESC').first
    end

    def of_month(year, month)
      find_or_create_by_year_and_month(year, month)
    end
  end

  belongs_to :tutor
  attr_accessible :current_amount, :expected_amount, :month, :tutor, :year

  validates_presence_of :tutor_id, :year, :month, :current_amount, :expected_amount
  validates_uniqueness_of :month, :scope => [:year, :tutor_id]

  def calculate
    lessons = tutor.lessons.of_settlement_month(year, month)
    self.expected_amount = lessons.inject(0){|sum, lesson| sum + lesson.tutor_total_wage}
    established_lessons = lessons.established
    self.current_amount = established_lessons.inject(0){|sum, lesson| sum + lesson.tutor_total_wage}
    if changed?
      save
    else
      touch
    end
    self
  end

  def new?
    created_at == updated_at
  end
end
