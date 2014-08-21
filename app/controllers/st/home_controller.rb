class St::HomeController < UserHomeController
  include StudentAccessControl
  student_only
end
