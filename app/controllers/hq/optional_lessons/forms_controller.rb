class Hq::OptionalLessons::FormsController < OptionalLessonFormsController
  hq_user_only

  private

    def finish_wizard_path
      pending_hq_lessons_path
    end

    def redirect_path_on_cancellation
      new_hq_optional_lesson_path
    end
end
