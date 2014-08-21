class Hq::OptionalLessonsController < ApplicationController
  hq_user_only
  layout 'with_sidebar'

  def new
    @optional_lesson = case params[:type]
                       when 'shared' then SharedOptionalLesson.new_for_form
                       when 'friends' then FriendsOptionalLesson.new_for_form
                       else OptionalLesson.new_for_form
                       end
  end

  def create
    current_user.clear_incomplete_lessons
    @optional_lesson = case params[:type]
                       when 'shared' then SharedOptionalLesson.new_for_form
                       when 'friends' then FriendsOptionalLesson.new_for_form
                       else OptionalLesson.new_for_form
                       end
    @optional_lesson.creator = current_user
    if @optional_lesson.save
      redirect_to hq_optional_lesson_forms_path(@optional_lesson, params)
    else
      render action:'new'
    end
  end
end
