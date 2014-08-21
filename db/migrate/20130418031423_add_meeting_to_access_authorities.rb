class AddMeetingToAccessAuthorities < ActiveRecord::Migration
  def change
    add_column :access_authorities, :meeting, :integer, :default => 0
  end
end
