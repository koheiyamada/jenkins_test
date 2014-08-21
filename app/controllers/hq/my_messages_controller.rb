class Hq::MyMessagesController < MyMessagesController
  include HqUserAccessControl
  hq_user_only
  access_control :message
end
