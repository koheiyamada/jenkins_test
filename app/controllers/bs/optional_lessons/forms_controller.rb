class Bs::OptionalLessons::FormsController < OptionalLessonFormsController
  bs_user_only
  #before_filter :prepare_student

  #def student
  #  if @optional_lesson.students.empty?
  #    @optional_lesson.students << @student
  #    @optional_lesson.save!
  #  end
  #  super
  #end

  private

    def finish_wizard_path
      pending_bs_lessons_path
    end

    def redirect_path_on_cancellation
      bs_lessons_path
    end

    def search_tutors(options)
      @tutor_search = TutorSearchForBsUsersAndOptionalLessons.new(options)
      @tutor_search.execute
    end

    def find_default_students(exclusions=[])
      students = current_user.students_for_lesson(@optional_lesson).only_active
      if exclusions.empty?
        students
      else
        students.where('users.id NOT IN (?)', exclusions)
      end
    end
end
