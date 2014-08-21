class Hq::MembershipApplicationsController < MembershipApplicationsController
  hq_user_only
  layout 'with_sidebar'

  def parents
    @membership_applications = MembershipApplication.of_parents.only_new.except_switching.order('created_at DESC').page(params[:page])
  end

  def students
    @membership_applications = MembershipApplication.of_students.only_new.except_switching.order('created_at DESC').page(params[:page])
  end

  #def requests
  #  @membership_applications = MembershipApplication.only_new.only_switching.order('created_at DESC').page(params[:page])
  #end

  private

    def path_on_rejected
      user = @membership_application.user
      if user.is_a? Student
        {action: :students}
      elsif user.is_a? Parent
        {action: :parents}
      else
        {action: :index}
      end
    end
end
