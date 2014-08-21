class CsSheet < ActiveRecord::Base

  class << self
    def written_by(user)
      where(author_id:user.id)
    end

    def for_list
      includes(:author)
    end
  end

  belongs_to :author, class_name:Student.name
  belongs_to :lesson
  attr_accessible :content, :score, :lesson, :author, :handout, :quiz, :reason_for_low_score

  validates_presence_of :author, :lesson, :score
  validates_presence_of :reason_for_low_score, :if => :low_score?
  validates_numericality_of :score, only_integer:true
  validates_inclusion_of :reason_for_low_score, :in => %w(bad_explanation many_mistakes many_small_talks mismatched pc_trouble others), :allow_nil => true
  #validates_uniqueness_of :author_id, scope: :lesson_id
  validates_uniqueness_of :lesson_id, scope: :author_id, message: :already_submitted

  validate :author_has_attended_lesson

  scope :only_good, where("score >= 4")
  scope :with_good_score, where('score >= 4')

  after_create do
    lesson.on_cs_sheet_created(self)
  end

  # userがこのCSシートのレッスンの担当者であればtrueを返す
  def tutor?(user)
    lesson && user && lesson.tutor == user
  end

  def tutor
    lesson && lesson.tutor
  end

  def good_score?
    score >= 5
  end

  def low_score?
    score && score <= 2
  end

  def subject_name
    lesson && lesson.subject_name
  end

  def cs_point
    if low_score?
      if reason_for_low_score == 'pc_trouble'
        0
      else
        if score == 1
          -3
        else
          score - 3
        end
      end
    else
      score - 3
    end
  end

  def date
    lesson && lesson.start_time.to_date
  end

  def start_time
    lesson && lesson.start_time
  end

  def end_time
    lesson && (lesson.ended_at || lesson.time_lesson_end || lesson.end_time)
  end

  private

    def author_has_attended_lesson
      if lesson && author && !lesson.student_attended?(author)
        errors.add(:author, :not_attended_lesson)
      end
    end
end
