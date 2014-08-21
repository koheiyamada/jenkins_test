class RemoveMembershipCancellation < ActiveRecord::Migration
  def up
    if table_exists? :membership_cancellations
      drop_table :membership_cancellations
    end
  end

  def down
  end
end
