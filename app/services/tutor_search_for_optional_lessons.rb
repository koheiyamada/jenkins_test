class TutorSearchForOptionalLessons < TutorSearch
  private

    def make_teaching_time_option
      TutorSearch::TeachingTimeOptionForOptionalLesson.new(params)
    end

    def tutor_ids_with_no_schedules
      []
    end

end