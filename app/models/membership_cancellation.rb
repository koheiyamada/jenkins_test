class MembershipCancellation < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user, :reason
  serialize :error_messages, Array

  validates_presence_of :user_id, :reason
  validates_inclusion_of :status, :in => %w(new done error)

  validate :user_can_cancel_membership_now

  before_create do
    user.on_canceling_membership self
  end

  after_create  :execute_in_background
  before_destroy :revive_user

  def new?
    status == 'new'
  end

  def error?
    status == 'error'
  end

  def done?
    status == 'done'
  end

  def execute
    transaction do
      if user.leave
        update_attribute :status, 'done'
      else
        self.error_messages = user.errors.full_messages
        self.status = 'error'
        save!
      end
      self
    end
  end

  private

    def lock_user
      user.lock.errors.empty?
    end

    def execute_in_background
      delay.execute
    end

    def user_can_cancel_membership_now
      user.validate_membership_cancellation(self)
    end

    def revive_user
      if user.present?
        user.revive.errors.empty?
      else
        false
      end
    end
end
