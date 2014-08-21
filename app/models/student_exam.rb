class StudentExam < ActiveRecord::Base
  belongs_to :student
  belongs_to :exam

  class << self
    def find_by_subject_and_month(s, month)
      includes(:exam).where(exams:{subject_id:(s.is_a?(Subject) ? s.id : s.to_i), month:month.beginning_of_month .. month.end_of_month}).first
    end
  end

  def start!
    if started_at.blank?
      self.started_at = Time.now
      save!
    end
  end

  def not_started?
    started_at.blank?
  end

  def done?
    started_at && (end_at < Time.now)
  end

  def in_progress?
    started_at && !done?
  end

  def end_at
    started_at && exam.duration.minutes.since(started_at)
  end
end
