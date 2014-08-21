class AddTypeToMembershipApplication < ActiveRecord::Migration
  def change
  	add_column :membership_applications, :type, :string
  	ActiveRecord::Base.connection.execute "update membership_applications set type = 'MembershipApplication' ;"
  end
end
