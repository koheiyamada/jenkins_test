class St::CsSheetsController < CsSheetsController
  include StudentAccessControl
  student_only
end
