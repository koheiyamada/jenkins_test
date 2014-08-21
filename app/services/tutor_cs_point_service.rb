class TutorCsPointService
  include Loggable

  RECENT_COUNT = 50

  def initialize(tutor)
    @tutor = tutor
  end

  attr_reader :tutor

  def update!
    update_total_cs_points!
    update_recent_cs_points!
    update_average_cs_point!
  end

  def update_total_cs_points!
    sum = tutor.lessons.with_cs_point.sum(:cs_point)
    tutor.info.update_attribute(:cs_points, sum)
  end

  def update_recent_cs_points!
    sum = calculate_sum_of_recent_cs_points(RECENT_COUNT)
    tutor.info.update_attribute(:cs_points_of_recent_lessons, sum)
  end

  def update_average_cs_point!
    average_cs_points = calculate_average_cs_point
    tutor.info.update_attribute(:average_cs_points, average_cs_points)
    logger.info "TUTOR:UPDATE id:#{tutor.id}, average_cs_points:#{average_cs_points}"
  end

  def calculate_average_cs_point
    tutor.lessons.with_cs_point.average(:cs_point) || 0
  end

  # チューターのCSポイントを計算する
  # @param count: カウントする直近のレッスン数。未指定の場合は全レッスンから計算する
  def calculate_sum_of_recent_cs_points(count)
    tutor.lessons.with_cs_point.order('start_time DESC').limit(count).sum(:cs_point) || 0
  end
end