class ErrorsController < ApplicationController

  def not_found
    logger.error "Not Found:#{request.fullpath}"
  end

  def server_error
  end

  def error_404
    render :status => 404
  end

  def error_500
    render :status => 500
  end

end
