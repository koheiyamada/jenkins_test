class St::TextbooksController < TextbooksController
  include StudentAccessControl
  include OnlyTextbooksUser
  student_only
end
