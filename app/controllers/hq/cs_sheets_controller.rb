class Hq::CsSheetsController < CsSheetsController
  include HqUserAccessControl
  hq_user_only
  access_control
end
