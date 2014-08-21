class Bs::InterviewsController < ApplicationController
  bs_user_only
  layout 'with_sidebar'

  def index
    @interviews = Interview.where(creator_id:current_user.id)
  end

  def show
    @interview = Interview.where(user2_id:current_user.id).find(params[:id])
    render layout:"interview"
  end

  # POST /bs/interviews/1/quit
  def quit
    redirect_to action:"index"
  end

  # POST /bs/interviews/1/done
  def done
    @interview = Interview.find(params[:id])
    @interview.done
    redirect_to action:"index"
  end

  def new
    @interview = Interview.new
  end

  def create
    @interview = Interview.new(params[:interview])
    @interview.creator = current_user
    if @interview.save
      redirect_to action:"index"
    else
      render action:"new"
    end
  end
end
