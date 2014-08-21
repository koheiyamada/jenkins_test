class UserMonthlyStat < ActiveRecord::Base
  class << self
    def of_month(year, month)
      where(year:year, month:month).first
    end
  end

  belongs_to :user
  attr_accessible :basic_lesson_cancellation_count, :month, :optional_lesson_cancellation_count, :year

  validates_presence_of :year, :month
  validates_numericality_of :year, :only_integer => true
  validates_numericality_of :month, :only_integer => true
  validates_uniqueness_of :month, :scope => [:user_id, :year]

  #after_create :update_usage # 作成後に一度集計を実行する

  def update_usage
    transaction do
      update_lesson_charge
      update_lesson_extension_charge
      save
      self
    end
  end

  def update_with_journal_entries

  end

  def year_month
    @year_month ||= Date.new(year, month)
  end

  def next_month
    year_month.next_month
  end

  def prev_month
    year_month.prev_month
  end

  private

    def update_lesson_charge
      if user.is_a?(Student)
        # この月の授業料（未実施分も含む）を再計算する
        self.lesson_charge = calculate_lesson_charge
        logger.debug "UserMonthlyStat#update_lesson_charge: user_id:#{user_id}"
      end
      self
    end

    def calculate_lesson_charge
      if user.student?
        Lesson.being_charged_to_student(user).of_settlement_month(year, month)
        .inject(0){|sum, lesson| sum + lesson.total_fee(user)}
      else
        0
      end
    end

    def update_lesson_extension_charge
      if user.is_a?(Student)
        extended_lessons = user.lessons.of_settlement_month(year, month).only_extended
        self.lesson_extension_charge = extended_lessons.inject(0){|sum, lesson| sum + lesson.extension_fee(user)}
      end
    end
end
