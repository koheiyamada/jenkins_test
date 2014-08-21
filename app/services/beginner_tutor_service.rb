class BeginnerTutorService
  def initialize(tutor)
    @tutor = tutor
  end

  attr_reader :tutor

  def remaining_lessons_count
    @remaining_lessons_count ||= calculate_remaining_lessons_count
  end

  def lesson_requests_limit
    @lesson_requests_limit ||= calculate_lesson_requests_limit
  end

  private

    def calculate_lesson_requests_limit
      Tutor.max_beginner_lessons_count - tutor.lessons.going_to_be_held.count
    end

    def calculate_remaining_lessons_count
      lessons = tutor.lessons
      n  = lessons.count
      n_done = lessons.only_done.count
      c_good = tutor.cs_sheets.only_good.count
      c_unreceived = tutor.unreceived_cs_sheets_count
      limit = Tutor.max_beginner_lessons_count
      if n <= limit - 2
        limit - n
      elsif n == limit - 1
        if c_good == 0
          if c_unreceived == 0
            2
          else
            1
          end
        else # Cg >= 1
          1
        end
      else # n >= limit
        if c_good == 0
          if c_unreceived == 0
            if n_done <= limit - 2
              0
            elsif n_done == limit - 1
              1
            else
              2
            end
          elsif c_unreceived == 1
            if n_done <= limit - 1
              0
            else # Ld == 10
              1
            end
          else # Cu >= 2
            0
          end
        elsif c_good == 1
          if c_unreceived == 0
            if n_done <= limit - 1
              0
            else
              1
            end
          else # Cu >= 1
            0
          end
        else # Cg >= 2
          0
        end
      end
    end
end