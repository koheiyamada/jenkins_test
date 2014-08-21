class St::MessagesController < MessagesController
  include StudentAccessControl
  student_only
end
