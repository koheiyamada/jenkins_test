class AddMaxCoachCountForAreaToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :max_coach_count_for_area, :integer, :default => 3
  end
end
