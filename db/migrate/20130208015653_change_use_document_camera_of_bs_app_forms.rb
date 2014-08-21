class ChangeUseDocumentCameraOfBsAppForms < ActiveRecord::Migration
  def up
    change_column :bs_app_forms, :use_document_camera, :boolean, :default => true
  end

  def down
    change_column :bs_app_forms, :use_document_camera, :string
  end
end
