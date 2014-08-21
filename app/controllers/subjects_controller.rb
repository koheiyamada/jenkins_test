class SubjectsController < ApplicationController
  def index
    @subjects = Subject.all
    respond_to do |format|
      format.json do
        render json: @subjects
      end
    end
  end

  def show
    @subject = Subject.find(params[i])
    respond_to do |format|
      format.json do
        render json: @subject
      end
    end
  end
end
