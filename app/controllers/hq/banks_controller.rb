class Hq::BanksController < BanksController
  include HqUserAccessControl
  hq_user_only
  access_control :bank
end
