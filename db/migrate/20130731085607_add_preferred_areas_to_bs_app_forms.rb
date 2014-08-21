class AddPreferredAreasToBsAppForms < ActiveRecord::Migration
  def change
    add_column :bs_app_forms, :preferred_areas, :string
  end
end
