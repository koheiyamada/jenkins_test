class Gu::TutorsController < TutorsController
  layout 'with_sidebar'

  def index
    if params[:college]
      params[:q] = ''
      @tutor_search = TutorSearch.new(params)
      @tutors = @tutor_search.execute
    else
      @tutors = Tutor.only_active.for_list.page(params[:page])
    end
  end

  def show
    @tutor = Tutor.find(params[:id])
  end
end
