class Tu::Lessons::ExtensionsController < ApplicationController
  include LessonRoom
  tutor_only
  before_filter :prepare_lesson

  def create
    @lesson_extension = @lesson.extend!
    respond_to do |format|
      format.json do
        if @lesson_extension.persisted?
          render json: lesson_to_json(@lesson_extension.lesson)
        else
          render json:{error_messages:@lesson_extension.errors.full_messages}, status: :not_acceptable
        end
      end
      format.js do
        if @lesson_extension.persisted?

        else

        end
      end
    end
  end
end
