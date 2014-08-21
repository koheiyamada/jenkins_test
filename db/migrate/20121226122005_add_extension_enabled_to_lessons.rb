class AddExtensionEnabledToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :extension_enabled, :boolean, :default => false
  end
end
