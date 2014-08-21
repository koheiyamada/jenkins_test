class Ts::LessonMaterialsController < St::Lessons::MaterialsController

  private

    def redirect_path_on_created(lesson)
      ts_lesson_path(lesson)
    end

    def redirect_path_on_deleted(lesson)
      ts_lesson_path(@lesson)
    end

end
