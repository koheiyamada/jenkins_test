class Hq::TextbooksController < TextbooksController
  include HqUserAccessControl
  hq_user_only
  access_control
end
