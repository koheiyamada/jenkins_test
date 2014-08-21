class St::LessonReportsController < LessonReportsController
  include StudentAccessControl
  student_only
end
