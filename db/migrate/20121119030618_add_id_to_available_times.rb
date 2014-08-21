class AddIdToAvailableTimes < ActiveRecord::Migration
  def change
    add_column :available_times, :id, :primary_key
  end
end
