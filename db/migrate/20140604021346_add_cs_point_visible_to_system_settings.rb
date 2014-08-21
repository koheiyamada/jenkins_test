class AddCsPointVisibleToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :cs_point_visible, :boolean, default: false
  end
end