class AddReasonToMembershipCancellations < ActiveRecord::Migration
  def change
    add_column :membership_cancellations, :reason, :text
  end
end
