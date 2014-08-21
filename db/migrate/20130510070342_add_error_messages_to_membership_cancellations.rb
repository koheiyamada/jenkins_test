class AddErrorMessagesToMembershipCancellations < ActiveRecord::Migration
  def change
    add_column :membership_cancellations, :error_messages, :text
  end
end
