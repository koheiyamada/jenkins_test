# coding:utf-8
module OptionalLessonMoneyMethods
  def self.included(base)
    base.has_one  :lesson_tutor_fee, class_name:Account::OptionalLessonTutorFee.name, foreign_key: :lesson_id, :dependent => :destroy
    base.has_many :lesson_fees,      class_name:Account::OptionalLessonFee.name, foreign_key: :lesson_id
  end
end
