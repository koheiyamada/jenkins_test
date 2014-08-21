class ChangeHasWebCameraOfTutorAppInfos < ActiveRecord::Migration
  def up
    change_column :tutor_app_forms, :has_web_camera, :string, :default => 'built_in'
    puts <<-END
#
#  RUN script/tutor_app_forms/reset_has_web_camera.rb
#
    END
  end

  def down
    change_column :tutor_app_forms, :has_web_camera, :boolean, :default => true
  end
end
