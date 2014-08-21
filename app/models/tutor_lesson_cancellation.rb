class TutorLessonCancellation < ActiveRecord::Base
  belongs_to :lesson
  attr_accessible :reason

  validates_presence_of :lesson_id, :reason
  validate :tutor_can_cancel

  after_create :cancel_lesson

  def tutor
    lesson.tutor
  end

  private

    def tutor_can_cancel
      unless lesson.cancellation_period_for? tutor
        errors.add :lesson, :not_cancellation_period
      end
    end

    def cancel_lesson
      unless lesson.cancel(lesson.tutor)
        # create後にエラーを発生させても、このインスタンスは persisted? => true
        # となり、idにも値がセットされているが、そのidに該当するデータは存在しない、という状態になる。
        # オブジェクトがエラー状態にあることを明確にするためにerrorsに項目を追加する。
        # これにより、errors.any? => trueとなるので、キャンセル処理に失敗したことを検出できる。
        errors.add :lesson, :failed_to_cancel
        raise ActiveRecord::Rollback.new("Failed to cancel lesson #{lesson.id}, #{lesson.errors.full_messages}")
      end
    end
end
