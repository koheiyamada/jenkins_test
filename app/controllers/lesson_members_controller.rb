class LessonMembersController < ApplicationController
  before_filter :prepare_lesson

  def index
    respond_to do |f|
      f.json{render json: @lesson.members.pluck(:id)}
    end
  end
end
