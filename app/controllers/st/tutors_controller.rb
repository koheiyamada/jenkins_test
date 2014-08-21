class St::TutorsController < TutorsController
  include StudentAccessControl
  include TutorSearchable
  student_only

  def index
    @subjects = current_user.subjects # for search box
    if params[:q]
      @tutor_search = TutorSearchForStudents.new(current_user, params)
      @tutors = @tutor_search.execute
    else
      @tutors = current_user.tutors.only_active.for_list.order('updated_at DESC').page(params[:page])
    end
  end

  def search
  end

  #def show
  #  @tutor = current_user.tutors.find(params[:id])
  #end

  def add_to_favorites
    @tutor = current_user.tutors.find(params[:id])
    current_user.favorite_tutors << @tutor
    redirect_to({action:"show"}, notice:t("messages.added_to_favorites"))
  end

  def remove_from_favorites
    @tutor = current_user.tutors.find_by_id(params[:id])
    if @tutor
      current_user.favorite_tutors.delete(@tutor)
    end
    redirect_to({action:"show"}, notice:t('messages.removed_from_favorites'))
  end

  def favorites
    # お気に入りは退会済みのチューターも含める。
    @tutors = current_user.favorite_tutors
  end

  def prof_search
    if params[:q]
      @tutors = current_user.search_tutors(params[:q], active:true)
    end
  end

  # GET tutors/cs
  def cs
    @tutors = current_user.tutors.only_active.includes(:info).order("tutor_infos.cs_points DESC, tutor_infos.total_lesson_units DESC").page(params[:page])
  end

  def cs_recent
    @tutors = current_user.tutors.only_active.includes(:info).order('tutor_infos.cs_points_of_recent_lessons DESC, tutor_infos.total_lesson_units DESC').page(params[:page])
  end

  # 自分がレッスンを受けたことのあるチューターを表示する
  # /st/tutors/lesson
  def lesson
    @tutors = current_user.lesson_tutors.only_active.includes(:info, :price).order('student_lesson_tutors.updated_at DESC').page(params[:page])
  end

  def new_optional_lesson
    @tutor = current_user.tutors.find_by_id(params[:id])

    current_user.clear_incomplete_lessons
    @optional_lesson = OptionalLesson.new_for_form
    @optional_lesson.creator = current_user
    @optional_lesson.tutor = @tutor
    @optional_lesson.students = [current_user]
    if @optional_lesson.save
      redirect_to st_optional_lesson_forms_path(@optional_lesson)
    else
      #render action:"error"
    end
  end
end
