class Hq::LessonReportsController < LessonReportsController
  include HqUserAccessControl
  hq_user_only
  access_control
end
