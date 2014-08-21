# coding:utf-8
module TutorMoneyMethods
  
  # 1レッスンあたりのベース授業料（生徒の学年を考慮しない）
  def base_lesson_fee
    price.base_lesson_fee
  end

  # このチューターが引数の受講者を１単位教える際のレッスン料を返す。
  # 仮登録チューターか否かで計算方法が違う。
  def lesson_fee_for_student(student)
    price.lesson_unit_fee(student)
  end

  # 遅刻で授業が取りやめになった場合の罰金
  def lesson_cancellation_penalty
    0 #wage_per_lesson_unit * 2
  end

  #############################################################
  # 賃金
  #############################################################

  # ベースの時給
  def hourly_wage
    price.hourly_wage
  end

  # 受講者に応じた時給
  def hourly_wage_for_student(student)
    if beginner?
      hourly_wage
    else
      hourly_wage + student.grade_premium
    end
  end

  def hourly_wage_for_grade(grade)
    if beginner?
      hourly_wage
    else
      hourly_wage + grade.premium
    end
  end

  # 受講者をふまえたレッスン１単位の賃金
  # レッスンごとの賃金は複数の生徒に依存するので、チューターの賃金の計算にこれが使われることはない。
  # 賃金計算表の確認用
  def lesson_unit_wage_for_student(student)
    hourly_wage_for_student(student) * Lesson.duration_per_unit / 60
  end

  def lesson_unit_wage_for_grade(grade)
    hourly_wage_for_grade(grade) * Lesson.duration_per_unit / 60
  end
end