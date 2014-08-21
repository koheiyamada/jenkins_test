class AddConfirmedAtToBsAppForms < ActiveRecord::Migration
  def change
    add_column :bs_app_forms, :confirmed_at, :datetime
  end
end
