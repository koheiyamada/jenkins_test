class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, :default => false

    update
  end

  def update
    HqUser.all.each do |u|
      u.update_column(:admin, true)
    end
  end
end
