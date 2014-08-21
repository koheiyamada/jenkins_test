class Bs::TutorsController < TutorsController
  include TutorSearchable
  bs_user_only
  layout 'with_sidebar'
  
  def index
    if params[:q]
      @tutor_search = TutorSearchForBsUsers.new(params)
      @tutors = @tutor_search.execute
    else
      @tutors = current_user.tutors.only_active.for_list.page(params[:page])
    end
  end
end
