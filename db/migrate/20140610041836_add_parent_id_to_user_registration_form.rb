class AddParentIdToUserRegistrationForm < ActiveRecord::Migration
  def change
  	add_column :user_registration_forms, :parent_id, :integer
  end
end
