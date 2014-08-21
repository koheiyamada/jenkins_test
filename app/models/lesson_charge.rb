# coding:utf-8

# レッスンに対する受講者の支払額を記録する
class LessonCharge < ActiveRecord::Base
  class << self
    def of_settlement_month(year, month)
      includes(:lesson_student => :lesson).where(lessons: {settlement_year: year, settlement_month: month})
    end
  end

  belongs_to :lesson_student
  belongs_to :organization
  attr_accessible :fee, :organization, :contains_bs_share

  validates_presence_of :lesson_student_id
  validates_presence_of :fee

  before_validation :setup

  # 受講者のレッスン料支払の仕訳データを作成する
  # 処理の実態はLessonStudent#journalizeにある。
  def journalize
    entry = lesson_student.journalize self
    if entry.persisted?
      self.update_column(:journalized, true)
    end
    entry
  end

  def student
    lesson_student.student
  end

  def bs_share
    contains_bs_share? ? calculate_bs_share : 0
  end

  private

    # LessonStudent.create_lesson_chargeから呼び出される（journalizeの前に呼び出しがある）
    def setup
      self.fee = lesson_student.lesson_fee # 割引、延長を含んだ金額
      self.organization = lesson_student.student.organization
      self.contains_bs_share = lesson_student.lesson.tutor.regular?
      self.contains_group_lesson_discount = lesson_student.group_lesson_discount_applied?
      self.contains_extension_fee = lesson_student.lesson.extended?
      true
    end

    def calculate_bs_share
      fee * SystemSettings.bs_share_of_lesson_sales
    end
end
