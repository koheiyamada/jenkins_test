class LessonAccounting
  include Loggable

  def initialize(lesson)
    @lesson = lesson
  end

  attr_reader :lesson

  def journalize!
    if lesson.established?
      journalize
    else
      lesson
    end
  end

  # このレッスンに関する仕訳を削除する
  def clear_journal_entries
    Lesson.transaction do
      lesson.journal_entries.destroy_all
      clear_tutor_wage
      lesson.lesson_charges.destroy_all
      lesson.update_column :accounting_status, 'unprocessed'
      lesson
    end
  end

  private

    def journalize
      logger.info "LessonAccounting#journalize #{lesson.id}"
      tutor_wage_entry = journalize_tutor
      logger.info "LessonAccounting#journalize tutor_wage_entry: #{tutor_wage_entry.persisted?}, tutor_id: #{lesson.tutor_id}"
      lesson_fee_entries = lesson.lesson_students.active.map do |lesson_student|
        if lesson_student.student.present?
          journalize_student(lesson_student).tap do |entry|
            logger.info "LessonAccounting#journalize student_entry: #{entry.persisted?}, student_id: #{lesson_student.student_id}"
          end
        end
      end
      lesson_fee_entries = lesson_fee_entries.compact
      update_journal_entries_status(tutor_wage_entry, *lesson_fee_entries)
      logger.info "LessonAccounting#journalize accouting_status: #{lesson.accounting_status}"
      lesson
    end

    def journalize_tutor
      lesson_tutor_wage = lesson.lesson_tutor_wage || lesson.create_lesson_tutor_wage!
      tutor_wage_entry = lesson_tutor_wage.journalize
      if tutor_wage_entry.errors.any?
        logger.lesson_log 'FAILED_TO_PAY_TUTOR_WAGE', error_messages: tutor_wage_entry.errors.full_messages
      end
      tutor_wage_entry
    end

    def journalize_student(lesson_student)
      lesson_charge = lesson_student.charge!
      lesson_fee_entry = lesson_charge.journalize
      if lesson_fee_entry.errors.any?
        logger.lesson_log 'FAILED_TO_CHARGE', error_messages: lesson_fee_entry.errors.full_messages
      end
      lesson_fee_entry
    end

    def update_journal_entries_status(*journal_entries)
      status = journal_entries.all?{|entry| entry.persisted?} ? 'processed' : 'incomplete'
      lesson.update_column :accounting_status, status
      lesson.touch :journalized_at
    end

    # 支払・請求データを作る
    def prepare_to_journalize!
      Lesson.transaction do
        if lesson.lesson_tutor_wage.blank?
          lesson.create_lesson_tutor_wage!
        end
        lesson.lesson_students.active.each do |lesson_student|
          lesson_student.charge!
        end
      end
    end

    def clear_tutor_wage
      if lesson.lesson_tutor_wage.present?
        lesson.lesson_tutor_wage.destroy
      end
    end
end