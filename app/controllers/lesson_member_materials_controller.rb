# coding: utf-8

#
# ここにアクセスしてくるのはスライドウィジェットなので、認証をかけると弾かれる。
#
class LessonMemberMaterialsController < ApplicationController
  #before_filter :authenticate_user!
  before_filter :prepare_lesson, :prepare_member, :set_access
  #before_filter :have_access?

  def index
    @lesson_materials = @lesson.materials.owned_by(@member)
    respond_to do |f|
      f.json do
        images = @lesson_materials.map{|material| lesson_member_material_url(@lesson, @member, material)}
        if images.length == 1
          images << "#{request.protocol}#{request.host_with_port}" + view_context.image_path('dot-transparent.png')
        end
        render json: {images: images}
      end
    end
  end

  def show
    @lesson_material = @lesson.materials.find(params[:id])
    send_file @lesson_material.file_path, disposition: 'inline'
  end

  private

    def prepare_member
      @member = User.find(params[:member_id])
    end

    def have_access?
      @lesson.member?(current_user) || current_user.hq_user? || current_user.coach_of?(@member)
    end

    def set_access
      response.headers["Access-Control-Allow-Origin"] = "*"
    end

end
