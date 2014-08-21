class StudentEmailConfirmationForm < EmailConfirmationForm
  private

  def save_form
    @user_form = StudentRegistrationForm.new(email: email)
    @user_form.save
  end
end