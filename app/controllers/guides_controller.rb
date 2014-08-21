class GuidesController < ApplicationController
  layout 'registration-centered'

  def show
    render params[:id]
  end
end
