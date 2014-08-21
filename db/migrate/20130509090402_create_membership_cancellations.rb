class CreateMembershipCancellations < ActiveRecord::Migration
  def change
    create_table :membership_cancellations do |t|
      t.references :user
      t.string :status, :default => 'new'

      t.timestamps
    end
    add_index :membership_cancellations, :user_id
  end
end
