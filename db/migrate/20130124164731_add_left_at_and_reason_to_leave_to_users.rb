class AddLeftAtAndReasonToLeaveToUsers < ActiveRecord::Migration
  def change
    add_column :users, :left_at, :datetime
    add_column :users, :reason_to_leave, :string
  end
end
