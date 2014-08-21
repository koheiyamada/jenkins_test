class ChangeHqAccountsToHqUser < ActiveRecord::Migration
  def up
    User.where(type: %w(HqAdmin HqAccountant HqSupport)).update_all(type:"HqUser")
  end

  def down
    HqUser.update_all(:type, "HqAdmin")
  end
end
