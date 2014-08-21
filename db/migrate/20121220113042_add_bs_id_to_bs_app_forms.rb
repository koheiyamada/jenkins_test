class AddBsIdToBsAppForms < ActiveRecord::Migration
  def change
    add_column :bs_app_forms, :bs_id, :integer
    add_index :bs_app_forms, :bs_id
  end
end
