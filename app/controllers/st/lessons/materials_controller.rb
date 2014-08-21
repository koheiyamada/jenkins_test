class St::Lessons::MaterialsController < ApplicationController
  student_only
  layout 'with_sidebar'
  before_filter :prepare_lesson

  def index
    @lesson_materials = @lesson.materials.owned_by(current_user)
    respond_to do |format|
      format.html
      format.json do
        #images = @lesson_materials.map{|material| st_lesson_material_url(@lesson, material)}
        images = @lesson_materials.map{|material| "#{request.scheme}://#{request.host}:#{request.port}" + material.url}
        render json:{images: images}
      end
    end
  end

  def new
    @lesson_material = LessonMaterial.new
  end

  def create
    @lesson_material = LessonMaterial.new(params[:lesson_material])
    @lesson_material.owner = current_user
    @lesson_material.lesson = @lesson
    if @lesson_material.save
      redirect_to redirect_path_on_created(@lesson), notice:t("messages.lesson_material_uploaded")
    else
      render action:"new"
    end
  end

  def show
    @lesson_material = LessonMaterial.find(params[:id])
    send_file @lesson_material.file_path, disposition:'inline'
  end

  def destroy
    @lesson_material = LessonMaterial.find(params[:id])
    @lesson_material.destroy
    redirect_to redirect_path_on_deleted(@lesson), notice: t('lesson_material.deleted')
  end

  private

    def prepare_lesson
      @lesson = Lesson.find(params[:lesson_id])
    end

    def redirect_path_on_created(lesson)
      st_lesson_path(lesson)
    end

    def redirect_path_on_deleted(lesson)
      st_lesson_path(@lesson)
    end
end
