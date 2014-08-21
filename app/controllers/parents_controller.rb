class ParentsController < UsersController
  layout 'with_sidebar'

  def index
    @parents = subject.parents.only_active.page(params[:page])
  end

  def left
    @parents = subject.parents.left.order('left_at DESC').page(params[:page])
  end

  def show
    @parent = subject.parents.find(params[:id])
  end

  def edit
    @edit_flg = true
    @parent = subject.parents.find(params[:id])
    @parent_form = ParentEntryForm.new(@parent)
  end

  def update
    @parent = subject.parents.find(params[:id])
    @parent_form = ParentEntryForm.new(@parent)
    if @parent_form.update(params)
      redirect_to action: 'show'
    else
      render :edit
    end
  end

  # GET /hq/ad/parents/:id/leave
  # POST /hq/ad/parents/:id/leave
  def leave
    @parent = subject.parents.find(params[:id])
    if request.post?
      @parent.leave!
      redirect_to({action:"index"}, notice:t("messages.parent_left"))
    end
  end

  def destroy
    @parent = subject.parents.find(params[:id])
    @parent.destroy
    redirect_to({action: 'index'}, notice: t('messages.user_deleted'))
  end

  private

  def subject
    current_user
  end
end
