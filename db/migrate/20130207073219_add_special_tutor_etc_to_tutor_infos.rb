class AddSpecialTutorEtcToTutorInfos < ActiveRecord::Migration
  def change
    add_column :tutor_infos, :special_tutor, :boolean, :default => false
    add_column :tutor_infos, :use_document_camera, :boolean, :default => true
  end
end
