class Hq::LessonMaterialsController < ApplicationController
  hq_user_only
  layout 'with_sidebar'

  def index
    @lesson_materials = LessonMaterial.order('created_at DESC').page(params[:page])
  end

  def lesson
    @lesson = Lesson.find(params[:lesson_id])
    @lesson_materials = @lesson.materials
    render layout: 'centered'
  end

end
