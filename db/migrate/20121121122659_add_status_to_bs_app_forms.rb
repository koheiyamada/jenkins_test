class AddStatusToBsAppForms < ActiveRecord::Migration
  def change
    add_column :bs_app_forms, :status, :string, :default => "new"
  end
end
