class CreateDocumentCameras < ActiveRecord::Migration
  def change
    create_table :document_cameras do |t|
      t.references :user

      t.timestamps
    end
    add_index :document_cameras, :user_id
  end
end
