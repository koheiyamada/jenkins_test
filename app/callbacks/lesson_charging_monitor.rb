class LessonChargingMonitor
  extend Loggable

  class << self
    def before_validation(lesson)
      # ベーシックレッスン、オプションレッスンともに、
      # チューター確定時・変更時にチューターのベース時給を記録する。
      if tutor_changing?(lesson)
        set_tutor_base_hourly_wage lesson
      end
      # ベーシックレッスンの場合のみ、課金確定時に料金を更新する
      if establishing?(lesson) && lesson.basic?
        set_tutor_base_hourly_wage lesson
      end
    end

    def before_save(lesson)

    end

    def after_update(lesson)
      if lesson.establishing?
        lesson.send :on_established
        logger.lesson_log('ESTABLISHED', lesson.attributes)
      end
      if lesson.journalized_at_changed?
        logger.lesson_log('JOURNALIZED', lesson.attributes)
        logger.charge_log('LESSON_JOURNALIZED', lesson.attributes)
      end
    end

    private

      def establishing?(lesson)
        lesson.established_changed? && lesson.established?
      end

      def tutor_changing?(lesson)
        lesson.tutor_id_changed? && lesson.tutor_id.present?
      end

      def set_tutor_base_hourly_wage(lesson)
        lesson.tutor_base_hourly_wage = lesson.tutor.hourly_wage
      end
  end
end