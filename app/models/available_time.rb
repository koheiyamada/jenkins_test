class AvailableTime < ActiveRecord::Base
  has_event_calendar

  class << self
    def containing(start_at, end_at)
      where("start_at <= :t1 && end_at >= :t2", t1:start_at, t2:end_at).present?
    end
  end

  belongs_to :tutor
  attr_accessible :start_at, :end_at

  scope :of_tutor, lambda{|tutor| where(tutor_id:tutor.id)}
  scope :of_day, lambda{|date| where("start_at >= :t1 AND end_at <= :t2", date.beginning_of_day, date.end_of_day)}

  def reserved_time_ranges
    basic_lesson_infos = tutor.basic_lesson_infos.overlap_with(start_at, end_at)
    optional_lessons = tutor.optional_lessons.overlap_with(start_at, end_at)
    {basic_lessons: basic_lesson_infos.map{|e| e.schedules.map{|s| [s.start_time, s.end_time]}}.flatten(1),
     optional_lessons: optional_lessons.map{|e| [e.start_time, e.end_time]}}
  end
end
