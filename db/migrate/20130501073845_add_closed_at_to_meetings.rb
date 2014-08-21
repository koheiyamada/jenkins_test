class AddClosedAtToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :closed_at, :datetime
  end
end
