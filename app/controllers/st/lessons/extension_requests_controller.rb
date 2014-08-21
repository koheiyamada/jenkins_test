class St::Lessons::ExtensionRequestsController < ApplicationController
  student_only
  before_filter :prepare_lesson

  def create
    @lesson_extension_request = @lesson.create_extension_request(current_user)
    respond_to do |format|
      format.json do
        if @lesson_extension_request.persisted?
          render json:@lesson_extension_request
        else
          render json:{error_messages:@lesson_extension_request.errors.full_messages}, status: :not_acceptable
        end
      end
      format.js do |format|
        if @lesson_extension_request.persisted?
          head status: :ok
        else
          head status: :not_acceptable
        end
      end
    end
  end

  def show
    @lesson_extension_request = @lesson.extension_request(current_user)
    respond_to do |format|
      format.json do
        if @lesson_extension_request.present?
          render json:@lesson_extension_request
        else
          head :not_found
        end
      end
    end
  end
end
