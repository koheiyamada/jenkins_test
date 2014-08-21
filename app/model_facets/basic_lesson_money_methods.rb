# coding:utf-8
module BasicLessonMoneyMethods
  def self.included(base)
    base.has_one  :lesson_tutor_fee, class_name:Account::BasicLessonTutorFee.name, foreign_key: :lesson_id, :dependent => :destroy
    base.has_many :lesson_fees,      class_name:Account::BasicLessonFee.name, foreign_key: :lesson_id
  end
end