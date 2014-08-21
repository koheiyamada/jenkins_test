class CreateMembershipApplications < ActiveRecord::Migration
  def change
    create_table :membership_applications do |t|
      t.references :user
      t.string :status, :default => 'new'

      t.timestamps
    end
    add_index :membership_applications, :user_id
  end
end
