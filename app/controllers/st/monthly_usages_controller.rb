class St::MonthlyUsagesController < MonthlyUsagesController
  include StudentAccessControl
  student_only
end
