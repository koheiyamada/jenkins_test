class StudentMembershipCancellationsController < UserMembershipCancellationsController
  prepend_before_filter do
    @user = current_user.students.find(params[:student_id])
    @student = @user
  end
end
