class Hq::TrialStudentsController < TrialStudentsController
  include HqUserAccessControl
  hq_user_only
  access_control :student
end
