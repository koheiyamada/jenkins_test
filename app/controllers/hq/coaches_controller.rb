class Hq::CoachesController < CoachesController
  include HqUserAccessControl
  hq_user_only
  access_control :bs_user
end
