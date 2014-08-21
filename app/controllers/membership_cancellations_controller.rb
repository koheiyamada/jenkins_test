class MembershipCancellationsController < ApplicationController
  before_filter :authenticate_user!
  layout 'with_sidebar'

  def new
    @membership_cancellation = current_user.build_membership_cancellation
  end

  def create
    @membership_cancellation = current_user.create_membership_cancellation(params[:membership_cancellation])
    respond_to do |format|
      format.json do
        if @membership_cancellation.errors.empty?
          render json: @membership_cancellation
        else
          render json: {error_messages: @membership_cancellation.errors.full_messages}, status: :unprocessable_entity
        end
      end
    end
  end

  def show
    @membership_cancellation = current_user.membership_cancellation
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

end
