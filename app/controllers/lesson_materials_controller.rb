class LessonMaterialsController < ApplicationController
  before_filter :prepare_lesson, :set_access
  layout 'with_sidebar'

  def index
    @lesson_materials = @lesson.materials
    respond_to do |format|
      format.json do
        #images = @lesson_materials.map{|material| "#{request.scheme}://#{request.host}:#{request.port}" + material.url}
        images = @lesson_materials.map{|material| lesson_material_url(@lesson, material)}
        if images.length == 1
          images << "#{request.protocol}#{request.host_with_port}" + view_context.image_path('dot-transparent.png')
        end
        render json:{images:images}
      end
    end
  end

  def create
    @lesson_material = LessonMaterial.new(params[:lesson_material])
    @lesson_material.owner = current_user
    @lesson_material.lesson = @lesson
    if @lesson_material.save
      redirect_to redirect_path_on_created(@lesson), notice: t('messages.lesson_material_uploaded')
    else
      render action: :new
    end
  end

  def new
    @lesson_material = @lesson.materials.build
  end

  def show
    @lesson_material = @lesson.materials.find(params[:id])
    send_file @lesson_material.file_path, disposition:'inline'
  end

  def destroy
    @lesson_material = @lesson.materials.find(params[:id])
    if @lesson_material.owner == current_user
      @lesson_material.destroy
    end
    redirect_to redirect_path_on_deleted(@lesson), notice: t('lesson_material.deleted')
  end

  private

    def prepare_lesson
      @lesson = Lesson.find(params[:lesson_id])
    end

    def set_access
      response.headers["Access-Control-Allow-Origin"] = "*"
    end

    def redirect_path_on_created(lesson)
      url_for(action: :index) + '/../'
    end

    def redirect_path_on_deleted(lesson)
      url_for(action: :index) + '/../'
    end
end
