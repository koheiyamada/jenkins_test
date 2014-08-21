class LessonSettingsController < ApplicationController
  layout 'with_sidebar'

  def show
    @lesson_settings = LessonSettings.instance
  end

  def edit
    @lesson_settings = LessonSettings.instance.dup
  end

  def create
    @lesson_settings = LessonSettings.instance.dup
    if @lesson_settings.update_attributes(params[:lesson_settings])
      redirect_to action: :show
    else
      render :edit
    end
  end
end
