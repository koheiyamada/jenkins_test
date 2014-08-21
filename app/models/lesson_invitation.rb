class LessonInvitation < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :student
  attr_accessible :status, :student

  validates_presence_of :lesson_id
  validates_inclusion_of :status, in: %w(new accepted rejected)
  validate :student_is_not_a_member, on: :create
  validate :lesson_is_going_to_be_held, on: :create
  validate :ensure_before_lesson_request_time_limit, if: :accepting?
  validate :ensure_can_be_new_status, if: :status_changed?

  after_update :on_status_changed, if: :status_changed?

  def new?
    status == 'new'
  end

  def accepted?
    status == 'accepted'
  end

  def rejected?
    status == 'rejected'
  end

  def active?
    new? && lesson.going_to_be_held? && before_acceptance_time_limit?
  end

  def responded?
    !new?
  end

  def accept
    update_attributes status: 'accepted'
  end

  def acceptance_time_limit
    lesson.request_time_limit
  end

  def before_acceptance_time_limit?
    Time.now < acceptance_time_limit
  end

  def reject
    update_attributes status: 'rejected'
  end

  private

    def accepting?
      status_changed? && status == 'accepted'
    end

    # status変更後に実行される処理
    def on_status_changed
      on_accepted if accepted?
      on_rejected if rejected?
    end

    def on_accepted
      unless lesson.member_student?(student)
        lesson.students << student
      end
    end

    def on_rejected
      if lesson.ready_to_start?
        lesson.open_and_notify
      end
    end

    # 受講者がすでに参加メンバーだと、エラーを追加する。
    def student_is_not_a_member
      if lesson.students.include? student
        errors.add :student, :already_a_member
      end
    end

    # レッスンが招待可能な状態でなければエラーを追加する。
    def lesson_is_going_to_be_held
      unless lesson.going_to_be_held? || lesson.build?
        errors.add :lesson, :not_going_to_be_held
      end
    end

    def ensure_before_lesson_request_time_limit
      unless before_acceptance_time_limit?
        errors.add :acceptance_time_limit, :over
      end
    end

    def ensure_can_be_new_status
      if responded? && status_was != 'new'
        errors.add :status, :cannot_be_new_status
      end
    end
end
