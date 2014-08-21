class AddTypeToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :type, :string
    add_index :meetings, :type
  end
end
