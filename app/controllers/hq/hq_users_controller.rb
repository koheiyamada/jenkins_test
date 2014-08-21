class Hq::HqUsersController < UsersController
  include HqUserAccessControl
  hq_user_only
  access_control
  layout 'with_sidebar'

  def index
    @hq_users = HqUser.page(params[:page])
  end

  def show
    @hq_user = HqUser.find(params[:id])
  end

  def new
    @hq_user = HqUser.new
  end

  def create
    @hq_user = HqUser.new(params[:hq_user])
    if @hq_user.save
      redirect_to action:"show", id:@hq_user
    else
      render action:"new"
    end
  end

  def edit
    @hq_user = HqUser.find(params[:id])
  end

  def change_password
    super
    @hq_user = @user
  end

  def update
    @hq_user = HqUser.find(params[:id])
    if @hq_user.update_attributes(params[:hq_user])
      redirect_to action:"show"
    else
      render action:"edit"
    end
  end

  def switch_admin_right
    @hq_user = HqUser.find(params[:id])
    case @hq_user.admin?
      when true
        @hq_user.admin = false
      when false
        @hq_user.admin = true
    end
    @hq_user.save!
    redirect_to action:"show", id:@hq_user
  end

  def destroy
    @hq_user = HqUser.find(params[:id])
    if @hq_user && !@hq_user.admin?
      @hq_user.destroy
    end
    redirect_to action:"index"
  end
end
