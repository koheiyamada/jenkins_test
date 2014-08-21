class LessonReport < ActiveRecord::Base
  include Searchable

  class << self
    def homework_result_options
      %w(good not_good no_homework)
    end

    def for_list
      includes(:student, :author)
    end
  end

  belongs_to :lesson
  belongs_to :author, class_name:Tutor.name
  belongs_to :student
  belongs_to :subject
  belongs_to :tutor
  attr_accessible :content, :lesson, :student, :author, :subject,
                  :subject_id, :tutor_id, :author_id,
                  :lesson_content, :textbook_usage, :has_attached_files,
                  :homework, :understanding, :note, :lesson_type,
                  :homework_result, :word_to_student

  validates_presence_of :lesson, :author, :student
  validates_presence_of :subject_id, :lesson_content, :homework_result,
                        :understanding, :word_to_student
  validates_uniqueness_of :lesson_id, scope: :student_id, message: :already_submitted # レポートは受講者ごとにレッスンあたり高々１つ

  searchable auto_index: false do
    integer :organization_id do
      author && author.organization_id
    end
    integer :author_id
    integer :student_id
    text :author do
      author && author.full_name
    end
    text :author_nickname do
      author && author.nickname
    end
    text :student do
      student && student.full_name
    end
    text :student_nickname do
      student && student.nickname
    end
    date :date do
      created_at.to_date
    end
  end

  before_validation do
    if lesson.present?
      self.start_at = lesson.start_time
      self.end_at = lesson.end_time
      self.started_at = lesson.started_at
      self.ended_at = lesson.ended_at
      #self.subject = lesson.subject
      self.tutor = lesson.tutor
      self.lesson_type = lesson.class.name
    end
  end

  def grade
    student && student.grade
  end

  def basic_lesson?
    lesson_type == "BasicLesson"
  end

  def optional_lesson?
    lesson_type == "OptionalLesson"
  end

  def date
    start_at.to_date
  end

  def start_time
    start_at
  end

  def end_time
    ended_at || end_at
  end

  def subject_name
    subject && subject.name
  end

  def prev
    older.order('id DESC').first
  end

  def next
    newer.order('id').first
  end

  def older
    student.lesson_reports.where('id < ?', id)
  end

  def newer
    student.lesson_reports.where('id > ?', id)
  end

  def has_older?
    older.present?
  end

  def has_newer?
    newer.present?
  end
end
