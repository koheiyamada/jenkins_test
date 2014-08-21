class Hq::Bss::BsUsersController < UsersController
  layout 'with_sidebar'
  before_filter :prepare_bs
  before_filter :only_readable
  before_filter :only_writable, :except => [:index, :show]

  def index
    @bs_users = @bs.bs_users
  end

  def show
    @bs_user = @bs.users.find(params[:id])
  end

  def edit
    @bs_user = @bs.users.find(params[:id])
  end

  def change_password
    @bs_user = @bs.users.find(params[:id])
    if request.put?
      if @bs_user.update_password(params[:bs_user])
        redirect_to({action:"show"}, notice:t("messages.password_updated"))
      end
    elsif request.get?
      if @bs_user.is_a?(Coach)
        @bs_user = @bs_user.becomes(BsUser)
      end
    end
  end

  def update
    @bs_user = @bs.users.find(params[:id])
    @bs_user_form = BsUserUpdateForm.new(@bs_user)
    if @bs_user_form.update(params)
      redirect_to action: :show
    else
      render :edit
    end
  end

  private

    def prepare_bs
      @bs = Bs.find(params[:bs_id])
    end

    def only_readable
      unless current_user.can_access?(:bs_user, :read)
        redirect_to hq_root_path
      end
    end

    def only_writable
      unless current_user.can_access?(:bs_user, :write)
        redirect_to action:"show"
      end
    end
end
