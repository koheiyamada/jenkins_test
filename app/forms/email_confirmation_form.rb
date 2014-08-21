class EmailConfirmationForm
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming

  attr_accessor :email_local, :email_domain
  attr_reader :user_form

  validates_presence_of :email
  validates_acceptance_of :agree_pledge

  def initialize(params = {})
    self.email_local = params[:email_local]
    self.email_domain = params[:email_domain]
    self.agree_pledge = params[:agree_pledge]
  end

  def save
    valid? && save_form
  end

  def email
    if email_local.present? && email_domain.present?
      "#{email_local}@#{email_domain}"
    end
  end

  def persisted?
    false
  end

  private
    def save_form
      false
    end
end