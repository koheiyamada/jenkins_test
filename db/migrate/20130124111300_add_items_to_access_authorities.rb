class AddItemsToAccessAuthorities < ActiveRecord::Migration
  def change
    add_column :access_authorities, :lesson, :integer, :default => 0
    add_column :access_authorities, :exam, :integer, :default => 0
    add_column :access_authorities, :message, :integer, :default => 0
    add_column :access_authorities, :document_camera, :integer, :default => 0
    add_column :access_authorities, :textbook, :integer, :default => 0
    add_column :access_authorities, :system_settings, :integer, :default => 0
    add_column :access_authorities, :bs_app_form, :integer, :default => 0
    add_column :access_authorities, :tutor_app_form, :integer, :default => 0
  end
end
