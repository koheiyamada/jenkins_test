class Hq::ExamsController < ApplicationController
  include HqUserAccessControl
  hq_user_only
  access_control
  layout 'with_sidebar'

  def index
    @grades = Grade.order_by_grade
  end

  # GET exams/:grade_id
  def grade
    @exam = Exam.new(grade:Grade.find(params[:grade_id]))
    @subjects = Subject.all
  end

  # GET exams/:grade_id/:subject_id
  def subject
    redirect_to :action => :year, :year => Date.today.year
  end

  # GET exams/:grade_id/:subject_id/:year
  def year
    @year = params[:year].to_i
    @exam = Exam.new do |exam|
      exam.grade = Grade.find(params[:grade_id])
      exam.subject = Subject.find(params[:subject_id])
      exam.month = Date.new(params[:year].to_i, Date.today.month)
    end
    @months = Array.new(12){|i| Date.new(@exam.month.year, i + 1)}
  end

  # GET exams/:grade_id/:subject_id/:year/:month
  def show
    @year = params[:year].to_i
    @month = params[:month].to_i
    month = Date.new(params[:year].to_i, params[:month].to_i)
    @exam = Exam.where(grade_id:params[:grade_id], subject_id:params[:subject_id]).of_month(month)
    if @exam.nil?
      redirect_to action:"new"
    end
  end

  # GET exams/:grade_id/:subject_id/:year/:month/new
  def new
    @year = params[:year].to_i
    @month = params[:month].to_i
    @exam = Exam.new do |exam|
      exam.grade = Grade.find(params[:grade_id])
      exam.subject = Subject.find(params[:subject_id])
      exam.month = Date.new(params[:year].to_i, params[:month].to_i)
    end
  end

  def file
    @year = params[:year].to_i
    @month = params[:month].to_i
    month = Date.new(@year, @month)
    @exam = Exam.where(grade_id:params[:grade_id], subject_id:params[:subject_id]).of_month(month)
    if @exam
      send_file @exam.file.current_path
    else
      redirect_to action:"new"
    end
  end

  def create
    @year = params[:year].to_i
    @month = params[:month].to_i
    @exam = Exam.new(params[:exam]) do |exam|
      exam.creator = current_user
      exam.grade = Grade.find(params[:grade_id])
      exam.subject = Subject.find(params[:subject_id])
      exam.month = Date.new(params[:year].to_i, params[:month].to_i)
    end
    if @exam.save
      redirect_to action:"show"
    else
      render action:"new"
    end
  end
end
