class InitDocumentCameras < ActiveRecord::Migration
  def up
    Student.only_active.each do |student|
      student.send :create_document_camera
    end

    Tutor.only_active.each do |tutor|
      tutor.send :create_document_camera
    end
  end

  def down
  end
end
