class MembershipApplicationsController < ApplicationController

  def index
    @membership_applications = MembershipApplication.order('created_at DESC').page(params[:page])
  end

  def create
    @membership_application = current_user.build_membership_application
    if @membership_application.save
      redirect_to path_on_created
    else
      render :new
    end
  end

  def show
    @membership_application = MembershipApplication.find(params[:id])
  end

  # POST membership_application/:id/accept
  def accept
    @membership_application = MembershipApplication.find(params[:id])
    @membership_application.accept
    #change_customer_type_to_premium
    if @membership_application.errors.empty?
      redirect_to({action: :show, id: @membership_application}, notice: t('membership_application.accepted'))
    else
      render :show
    end
  end

  # POST membership_application/:id/reject
  def reject
    @membership_application = MembershipApplication.find(params[:id])
    @membership_application.reject
    if @membership_application.errors.empty?
      redirect_to path_on_rejected, notice: t('membership_application.rejected')
    else
      render :show
    end
  end

  private

    def path_on_created
      root_path
    end

    def path_on_rejected
      {action: :index}
    end

    def change_customer_type_to_premium
      target_user = User.find(MembershipApplication.find(params[:id]).user_id)
      if target_user.type == "Parent"
        students = target_user.students
        students.each do |student|
          if student.customer_type == "request_to_premium"
            student.to_premium
          end
        end
      end
      target_user.to_premium
    end
end
