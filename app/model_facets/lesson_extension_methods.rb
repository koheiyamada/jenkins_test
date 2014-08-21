# coding:utf-8
module LessonExtensionMethods
  def self.included(base)
    base.has_one :lesson_extension, :dependent => :destroy
    base.has_one :lesson_extendability, :dependent => :destroy
  end

  def extendable?
    extendability.persisted?
  end

  def extendability
    lesson_extendability || create_lesson_extendability
  end

  # レッスンが延長可能かどうかをチェックする。
  # 延長可能な場合はnilを返す。
  # 延長できない場合はその理由を表す文字列を返す。
  def check_extendability
    if open?
      next_lesson = tutor.next_lesson_of(self)
      if next_lesson && next_lesson.conflict?(start_time..end_time_after_extended, 15)
        "つぎのレッスンと時間がかぶるため延長できない"
      elsif !students.all?{|student| student.can_pay_lesson_extension_fee?(self)}
        "生徒の延長料金残額が不足しているため延長できない"
      else
        # 延長可能なケース
        nil
      end
    else
      "レッスンがまだ開始されていないため延長できない"
    end
  end

  # 生徒がレッスン延長に申し込む
  # 作成された延長申込オブジェクトを返す。
  # エラーの場合は戻り値のerrors.any?がtrueとなる。
  def create_extension_request(student)
    lesson_student = student.of_lesson(self)
    if lesson_student.lesson_extension_request.present?
      lesson_student.lesson_extension_request
    else
      student.of_lesson(self).create_lesson_extension_request.tap do |obj|
        if obj.new_record?
          logger.lesson_log('EXTENSION_REQUEST_FAILED',
                            log_attributes.merge(student:student.id, error_messages:obj.errors.full_messages))
        end
      end
    end
  end

  def extend!
    lesson_extension || create_lesson_extension
  end

  def extension_requests
    LessonExtensionRequest.joins(:lesson_student).where(lesson_students:{lesson_id:id})
  end

  def extension_request(student)
    student.of_lesson(self).lesson_extension_request
  end

  def extension_requested_by_all_attended_students?
    students = lesson_students.attended
    students.present? && students.includes(:lesson_extension_request).where(lesson_extension_requests:{id:nil}).empty?
  end
end