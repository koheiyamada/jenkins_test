class InitOrganizationRepresentatives < ActiveRecord::Migration
  def up
    Bs.all.each do |bs|
      bs.representative = bs.bs_users.first
      bs.address = Address.new_dummy
      bs.email = 'shimokawa@soba-project.com' if bs.email.blank?
      bs.phone_number = '1111-1111-1111' if bs.phone_number.blank?
      bs.save!
    end
    Headquarter.all.each do |hq|
      hq.representative = hq.hq_users.first
      hq.save!
    end
  end

  def down
  end
end
