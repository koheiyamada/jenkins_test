class Bs::StudentOptionalLessonsController < ApplicationController
  bs_user_only
  layout 'with_sidebar'
  before_filter :prepare_student

  def index
    @lessons = current_user.optional_lessons
  end

  def show
  end

  def new
    @lesson = OptionalLesson.new
    @units = (@student.min_lesson_units .. 5)
  end

  def create
    @lesson = OptionalLesson.new(params[:optional_lesson]) do |lesson|
      lesson.students = [@student]
    end
    if @lesson.save
      redirect_to action:"index"
    else
      render action:"new"
    end
  end
end
