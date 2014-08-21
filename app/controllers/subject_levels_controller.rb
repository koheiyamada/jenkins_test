class SubjectLevelsController < ApplicationController
  before_filter do
    @subject = Subject.find(params[:subject_id])
  end

  def index
    @levels = @subject.levels
    respond_to do |format|
      format.json do
        render json: @levels.as_json(methods: :name)
      end
    end
  end

  def show
    @level = @subject.levels.find(params[:id])
    respond_to do |format|
      format.json do
        render json: @level.as_json(methods: :name)
      end
    end
  end
end
