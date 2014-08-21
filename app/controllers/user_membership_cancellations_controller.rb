class UserMembershipCancellationsController < ApplicationController
  layout 'with_sidebar'

  def new
    @membership_cancellation = user.build_membership_cancellation
  end

  def create
    @membership_cancellation = user.create_membership_cancellation(params[:membership_cancellation])
    respond_to do |format|
      format.json do
        if @membership_cancellation.errors.empty?
          render json: @membership_cancellation
        else
          render json: {error_messages: @membership_cancellation.errors.full_messages}, status: :unprocessable_entity
        end
      end
      format.html do
        if @membership_cancellation.errors.empty?
          redirect_to action: 'show'
        else
          render :new
        end
      end
    end
  end

  def show
    @membership_cancellation = user.membership_cancellation
    respond_to do |format|
      format.html

      format.json do
        if @membership_cancellation
          render json: @membership_cancellation
        else
          head :not_found
        end
      end
    end
  end

  def destroy
    if user.membership_cancellation.present?
      user.membership_cancellation.destroy
    else
      logger.error 'user does not have membership cancellation object'
    end
    redirect_to redirect_path_on_destroyed
  end

  private

    def redirect_path_on_created
      url_for(action: :show) + '/..'
    end

    helper_method :redirect_path_on_created

    def redirect_path_on_destroyed
      url_for(action: :show) + '/..'
    end

    def user
      @user
    end
end
