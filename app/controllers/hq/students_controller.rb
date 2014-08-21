class Hq::StudentsController < StudentsController
  include HqUserAccessControl
  hq_user_only
  access_control :student

  def billing
    @students = Student.only_active.only_independent.page(params[:page])
  end

  private

    def only_readable
      unless current_user.can_access?(:student, :read)
        redirect_to hq_root_path
      end
    end

    def only_writable
      unless current_user.can_access?(:student, :write)
        redirect_to action:"show"
      end
    end
end
