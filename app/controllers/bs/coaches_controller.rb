class Bs::CoachesController < CoachesController
  bs_user_only
  block_coach

  def index
    @coaches = current_user.coaches.page(params[:page])
  end

  def activate
    @coach = find_coach_by_id(params[:id])
    if @coach.activate
      redirect_to action: :show
    else
      render action: :show_inactive
    end
  end

  def deactivate
    @coach = find_coach_by_id(params[:id])
    if @coach.deactivate
      redirect_to action: :show
    else
      render :show_active
    end
  end

  private

    def find_coach_by_id(id)
      current_user.coaches.find(id)
    end

end
