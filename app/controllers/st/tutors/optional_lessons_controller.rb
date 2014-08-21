class St::Tutors::OptionalLessonsController < ApplicationController
  student_only
  layout 'with_sidebar'
  before_filter :prepare_tutor
  before_filter :check_if_special_tutor_for_free_user

  def new
    @optional_lesson = OptionalLesson.new do |lesson|
      lesson.creator = current_user
      lesson.tutor = @tutor
      lesson.students = [current_user]
    end
    @free_lesson_limit_number = current_user.free_lesson_limit_number
    if session[:free_for_special_tutor_flg] == true
      @free_for_special_tutor_flg = true
    else
      @free_for_special_tutor_flg = false
    end
  end

  def create
    if session[:free_for_special_tutor_flg] == true
      redirect_to action:'new'
    else
      current_user.clear_incomplete_lessons
      @optional_lesson = case params[:type]
                         when 'shared' then SharedOptionalLesson.new_for_form
                         when 'friends' then FriendsOptionalLesson.new_for_form
                         else OptionalLesson.new_for_form
                         end
      @optional_lesson.creator = current_user
      @optional_lesson.tutor = @tutor
      @optional_lesson.students = [current_user]
      if @optional_lesson.save
        redirect_to st_optional_lesson_forms_path(@optional_lesson)
      else
        render action:'new'
      end
    end
  end

  private

  def check_if_special_tutor_for_free_user
    if @tutor.special? && current_user.free?
      session[:free_for_special_tutor_flg] = true
    else
      session[:free_for_special_tutor_flg] = false
    end
  end
end
