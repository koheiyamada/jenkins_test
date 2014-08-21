class AddPhotoToBsAppForms < ActiveRecord::Migration
  def change
    add_column :bs_app_forms, :photo, :string
  end
end
