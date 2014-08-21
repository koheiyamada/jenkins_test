# coding:utf-8
TutorAppForm.all.each do |tutor_app_form|
  if tutor_app_form.tutor_id # すでに削除されたチューターのエントリーフォームも含める
    unless tutor_app_form.rejected?
      puts "Reset tutor app form #{tutor_app_form.id} status from #{tutor_app_form.status} to accepted"
      tutor_app_form.update_attribute(:status, 'accepted')
    end
  end
end
