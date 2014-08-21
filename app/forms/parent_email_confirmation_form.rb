class ParentEmailConfirmationForm < EmailConfirmationForm
  private

  def save_form
    @user_form = ParentRegistrationForm.new(email: email)
    @user_form.save
  end
end