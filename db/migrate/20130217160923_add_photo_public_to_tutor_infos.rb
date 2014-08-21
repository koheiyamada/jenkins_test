class AddPhotoPublicToTutorInfos < ActiveRecord::Migration
  def change
    add_column :tutor_infos, :photo_public, :boolean, :default => false
  end
end
