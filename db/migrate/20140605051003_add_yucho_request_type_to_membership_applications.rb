class AddYuchoRequestTypeToMembershipApplications < ActiveRecord::Migration
  def change
  	add_column :membership_applications, :yucho_request_type, :string
  end
end
