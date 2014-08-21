class UserRegistrationEmail < ActiveRecord::Base

  belongs_to :user

  attr_accessible :email

  validates_presence_of :email
  validates_format_of :email, :with => User.mail_address_pattern, :message => :unacceptable_format, :unless => :development_or_test?

  before_create :publish_confirmation_token

  after_create do
    Mailer.send_mail(:change_email_parent, self.email, self.token)
  end

  after_create do
    Mailer.send_mail(:change_email_student, self.email, self.token)
  end

  after_create do
    Mailer.send_mail(:change_email_hq_user, self.email, self.token)
  end

  after_create do
    Mailer.send_mail(:change_email_bs_user, self.email, self.token)
  end

  after_create do
    Mailer.send_mail(:change_email_tutor, self.email, self.token)
  end

  private

    def publish_confirmation_token
      self.token = generate_token
    end

    def generate_token
      charset = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
      Array.new(32){ charset.sample }.join
    end

end
