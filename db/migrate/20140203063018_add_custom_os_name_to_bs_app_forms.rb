class AddCustomOsNameToBsAppForms < ActiveRecord::Migration
  def change
    add_column :bs_app_forms, :custom_os_name, :string
  end
end
