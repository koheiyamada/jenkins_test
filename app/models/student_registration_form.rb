class StudentRegistrationForm < UserRegistrationForm
  belongs_to :student, :foreign_key => :user_id

  after_create do
    Mailer.send_mail(:student_registration_form_created, self)
  end

end
