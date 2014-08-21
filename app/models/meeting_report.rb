class MeetingReport < ActiveRecord::Base
  belongs_to :meeting
  belongs_to :author, class_name: User.name
  attr_accessible :text, :author, :subjects, :lesson_type

  validates_presence_of :author_id, :text, :meeting_id
  validates_inclusion_of :lesson_type, :in => %w(basic_lesson optional_lesson), :allow_blank => true
end
