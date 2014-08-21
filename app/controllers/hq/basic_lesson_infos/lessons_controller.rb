class Hq::BasicLessonInfos::LessonsController < BasicLessonInfoLessonsController
  include HqUserAccessControl
  hq_user_only
  access_control :lesson
end
