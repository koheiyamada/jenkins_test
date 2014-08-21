class Hq::ParentsController < ParentsController
  include HqUserAccessControl
  hq_user_only
  access_control

  def index
    if params[:q] || params[:search]
      page = params[:page] || 1
      @parents = current_user.search_parents(
        params[:q], active: true, page: page, conditions: params[:search])
    else
      @parents = current_user.parents.only_active.for_list.page(params[:page])
    end

    if ["HqUser", "SystemAdmin"].include? current_user.type
      @customer_type = User.new.customer_type_for_select_box
    end

    if params[:search]
      session[:search] = params[:search]
    else
      session[:search] = nil
      @search_data = {"customer_type"=>nil}
    end

    if session[:search]
      @search_data = session[:search]
    end



    @parents.reject! do |pr|
      found_type = pr.students.map(&:customer_type).include? @search_data["customer_type"]
      if @search_data["customer_type"].blank?
        pr.students.size.zero?
      else
        pr.students.size.zero? or not found_type
      end
    end
  end

  def activate
    @parent = Parent.find(params[:id])
    if @parent.active?
      redirect_to action:'show'
    else
      if request.post?
        if @parent.revive
          redirect_to({action:'show'}, notice:t('messages.account_activated'))
        end
      end
    end
  end

  def change_email
    raise current_user.inspect
    @parent = current_user
    if request.post?
      temp_user = UserRegistrationForm.find(current_user.id)
      @parent_form = UserRegistrationEmail.new
      @parent_form.user_id = current_user.id
      @parent_form.email = params[:email_confirmation_form]["email_local"]+"@"+params[:email_confirmation_form]["email_domain"]
      @parent_form.token = temp_user.confirmation_token
      @parent_form.save
      HqUserMailer.change_email_parent(@tutor_form.email,@tutor_form.token).deliver
      redirect_to root_path
    end
  end

  def email_confirmation
    if params[:token].present?
      token = params[:token]
      if emailc = UserRegistrationEmail.find_by_token(token)
        @parent = emailc.user
        @parent.email = emailc.email
        @parent.save
        render :change_email_confirmation
      else
        render :change_email_confirmation_error
      end
    else
      render :change_email_confirmation_error
    end
  end

end
