class HomeController < ApplicationController

  def index
    if user_signed_in?
      redirect_to current_user.root_path
    else
      redirect_to sign_in_path
    end
  end

  def registration
    redirect_to '/confirmation1'
  end

  def left

  end

  def version
    @version = Aid.version
  rescue => e
    logger.error e
    @version = '?'
  end
end
