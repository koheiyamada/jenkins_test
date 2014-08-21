class CoachesController < UsersController
  layout 'with_sidebar'

  def index
    if params[:q].present?
      page = params[:page] || 1
      @coaches = CoachSearch.new(current_user).search_active_coaches(params[:q], page: page)
    else
      @coaches = Coach.only_active.for_list.page(params[:page])
    end
  end

  def left
    if params[:q].present?
      page = params[:page] || 1
      @coaches = CoachSearch.new(current_user).search_left_coaches(params[:q], page: page)
    else
      @coaches = Coach.inactive.for_list.page(params[:page])
    end
  end

  def new
    @coach = Coach.new do |c|
      c.user_name = Coach.generate_user_name
      c.password = Coach.generate_password
      c.address = Address.new
    end
  end

  def create
    @coach = Coach.new(params[:coach]) do |coach|
      coach.address = Address.new(params[:address])
    end
    if @coach.save
      redirect_to action: :show, id: @coach
    else
      render :new
    end
  end

  def show
    @coach = find_coach_by_id(params[:id])
  end

  def edit
    @coach = find_coach_by_id(params[:id])
  end

  def change_password
    super
    @coach = @user
  end

  def update
    @coach = find_coach_by_id(params[:id])
    @coach.attributes = params[:coach]
    @coach.address = Address.new(params[:address])
    if @coach.save
      redirect_to action: :show
    else
      render :edit
    end
  end

  def destroy
    @coach = find_coach_by_id(params[:id])
    @coach.destroy
    if @coach.errors.empty?
      redirect_to action: :index
    else
      render :show
    end
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
      Coach.find(id)
    end
end
