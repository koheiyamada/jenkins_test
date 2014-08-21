class Hq::SwitchingPaymentMethodUsersController < ApplicationController
  include HqUserAccessControl
  hq_user_only
  access_control :accounting
  def index
  end
end
