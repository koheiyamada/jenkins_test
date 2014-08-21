class ParentRegistrationForm < UserRegistrationForm
  belongs_to :parent, :foreign_key => :user_id

  after_create do
    Mailer.send_mail(:parent_registration_form_created, self)
  end

end
