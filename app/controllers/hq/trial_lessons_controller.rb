class Hq::TrialLessonsController < Hq::LessonsController

  private

  def lessons
    TrialLesson.scoped
  end
end
