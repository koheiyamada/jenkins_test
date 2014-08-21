#### 入会申込を管理するモデル
class MembershipApplication < ActiveRecord::Base
  # YuchoAccountApplicationとの切り分け
  default_scope where(type: self.name)

  scope :of_students, joins(:user).where(users: {type: Student.name})
  scope :of_parents, joins(:user).where(users: {type: Parent.name})
  scope :only_new, where(status: 'new')
  ###ゆうちょ申込したユーザーの種別を切り分けるためのスコープ
  scope :only_switching, where(yucho_request_type: 'switch_to_yucho')
  scope :except_switching, where("yucho_request_type != 'switch_to_yucho' or yucho_request_type is NULL")
  scope :only_free_to_premium, where(yucho_request_type: 'free_to_yucho')
  scope :only_new_premium, where(yucho_request_type: 'new_yucho')


  belongs_to :user

  attr_accessible :user

  validates_presence_of :user_id
  validates_inclusion_of :status, in: %w(new accepted rejected)
  validate :user_has_bank_account

  before_create :check_yucho_request_type, unless: :switching?
  after_create  :on_created
  before_update :on_status_changing, if: :status_changed?
  after_update  :on_status_changed, if: :status_changed?

  def accept
    self.status = 'accepted'
    self.yucho_request_type = nil
    if save
      logger.info "Membership application of #{user.type} #{user.id} was accepted"
    else
      logger.warn "Membership application of #{user.type} #{user.id} was not accepted"
    end
    self
  end

  def reject
    self.status = 'rejected'
    save
    self
  end

  def new?
    status == 'new'
  end

  def accepted?
    status == 'accepted'
  end

  def rejected?
    status == 'rejected'
  end

  def switching?
    yucho_request_type == 'switch_to_yucho'
  end

  private

    def on_status_changing
      if accepted?
        on_being_accepted
      end
    end

    def on_status_changed
      if rejected?
        on_rejected
      end
    end

    def user_has_bank_account
      if user.bank_account.blank?
        errors.add :user, :does_not_have_bank_account
      end
    end

    def on_being_accepted
      user.on_membership_application_accepted(self)
    end

    def on_rejected
      Mailer.send_mail :membership_application_rejected, self
      user.on_membership_application_rejected(self)
    end

    def on_created
      unless user.active?
        Mailer.send_mail_async :membership_application_created, self
      else
        Mailer.send_mail(:membership_application_created_at_free_user, self)
      end
    end

    def check_yucho_request_type
      user_customer_type = user.customer_type
      case user_customer_type
      when "premium"
        self.yucho_request_type = 'switch_to_yucho'
      when "request_to_premium"
        self.yucho_request_type = 'free_to_yucho'
      when nil
        self.yucho_request_type = 'new_yucho'
      else
        raise "Yucho Wrong Request. %s => %s" % [user_customer_type,self.yucho_request_type]
      end
    end
end
