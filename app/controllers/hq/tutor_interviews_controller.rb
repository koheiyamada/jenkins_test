class Hq::TutorInterviewsController < Hq::BaseController
  def index
    @forms = TutorAppForm.order("created_at DESC")
  end
end
