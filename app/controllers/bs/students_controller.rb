class Bs::StudentsController < ApplicationController
  bs_user_only
  layout 'with_sidebar'
  
  def index
    @students = current_user.students.includes(:coach, :student_info => :grade).only_active.page(params[:page])
  end

  def left
    @students = current_user.students.left.page(params[:page])
  end

  def show
    @student = current_user.students.find(params[:id])
  end

  def edit
    @student = current_user.students.find(params[:id])
    @student.build_address if @student.address.blank?
  end

  def update
    ActiveRecord::Base.transaction do
      address = Address.new(params[:address])
      @student = current_user.students.find(params[:id])
      @student.address = address
      @student.update_attributes!(params[:student])
      @student.student_info.update_attributes!(params[:student_info])
      redirect_to bs_student_path(@student)
    end
  rescue => e
    logger.warn e
    render action:"edit"
  end

  def leave
    @student = current_user.students.find(params[:id])
    if request.post?
      @student.leave!
      redirect_to({action:"index"}, notice:t("messages.student_left"))
    end
  end
end
