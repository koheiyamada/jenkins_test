class Bs::ParentsController < ParentsController
  bs_user_only
  layout 'with_sidebar'

  def index
    @parents = current_user.active_parents.for_list.page(params[:page])
  end

  def show
    @parent = Parent.find(params[:id])
  end
end
