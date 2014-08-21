ActiveRecord::Base.transaction do
  TutorAppForm.all.each do |form|
    case form.has_web_camera
    when '1'
      form.update_column :has_web_camera, 'build_in'
    when '0'
      form.update_column :has_web_camera, 'no'
    else

    end
  end
end