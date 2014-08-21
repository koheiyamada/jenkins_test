class Interview < ActiveRecord::Base
  belongs_to :creator, class_name:User.name
  belongs_to :user1, class_name:User.name
  belongs_to :user2, class_name:User.name
  attr_accessible :end_time, :note, :start_time, :duration, :user1_id, :user2_id
  attr_accessor :duration

  validates_presence_of :user1, :user2, :start_time
  validates_numericality_of :duration, :only_integer => true, :greater_than => 0

  before_save do
    if start_time && duration
      self.end_time = duration.to_i.minutes.since(start_time)
    end
  end

  # mark this interview as 'done'
  def done
    update_attribute(:finished_at, Time.now) if finished_at.blank?
  end

  def done?
    finished_at.present?
  end

  def participant_apart_from(user)
    if user1 && user1 != user
      user1
    elsif user2 && user2 != user
      user2
    end
  end
end
