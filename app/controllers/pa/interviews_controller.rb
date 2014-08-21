class Pa::InterviewsController < ApplicationController
  include ParentAccessControl
  parent_only
  layout 'with_sidebar'

  def index
    @interviews = current_user.interviews
  end

  def show
    @interview = current_user.interviews.find(params[:id])
    render layout:"interview"
  end
end
