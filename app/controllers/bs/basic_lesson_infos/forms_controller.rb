class Bs::BasicLessonInfos::FormsController < BasicLessonInfoFormsController
  bs_user_only

  private
    def finish_wizard_path
      pending_bs_basic_lesson_infos_path
    end

    def redirect_path_on_cancellation
      bs_basic_lesson_infos_path
    end

    def search_tutors(options)
      @tutor_search = TutorSearchForBsUsers.new(options)
      @tutor_search.execute
    end

    def find_default_students(exclusions=[])
      students = current_user.students_for_lesson(@basic_lesson_info).only_active
      if exclusions.empty?
        students
      else
        students.where('users.id NOT IN (?)', exclusions)
      end
    end
end
