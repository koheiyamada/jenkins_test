class AddCustomOsNameToTutorAppForms < ActiveRecord::Migration
  def change
    add_column :tutor_app_forms, :custom_os_name, :string
  end
end
