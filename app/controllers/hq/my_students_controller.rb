class Hq::MyStudentsController < Hq::StudentsController
  hq_user_only

  def index
    if params[:q]
      @students = subject.search_students(params[:q], active:true, organization_id:current_user.organization_id)
    else
      @students = subject.students.only_active.of_organization(current_user.organization).page(params[:page])
    end
  end
end
