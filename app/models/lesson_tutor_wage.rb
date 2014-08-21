# coding:utf-8

# このクラスはチューターへのレッスンの賃金を計算・記録するためのものである。
# チューターの賃金は時によって変化するので、レッスンごとの支払額を記録する。
# 同時レッスンによる増額、延長料金を含んでいるかどうかも記録する。
#
class LessonTutorWage < ActiveRecord::Base
  belongs_to :lesson
  attr_accessible :group_lesson_premium, :wage

  validates_presence_of :wage, :lesson_id

  before_validation :setup

  def total_wage
    (wage * (1 + SystemSettings.instance.tax_rate)).to_i
  end

  def tutor
    lesson && lesson.tutor
  end

  # チューターへの支払仕訳を作成する。
  # 失敗したらペンディング状態にする。
  def journalize
    lesson.lesson_tutor_fee || create_lesson_tutor_fee
  end

  private

    def create_lesson_tutor_fee
      entry = lesson.create_lesson_tutor_fee(owner: lesson.tutor, amount_of_money_received: wage)
      update_attribute :journalized, entry.persisted?
      if entry.errors.any?
        logger.error entry.errors.full_messages
      end
      entry
    end

    def setup
      self.wage = lesson.tutor_total_wage
      self.includes_extension_wage = lesson.extended?
      self.includes_group_lesson_premium = lesson.group_lesson?
      true
    end
end
