# encoding:utf-8

FactoryGirl.define do
  factory :tutor_info do
    tutor nil
    photo "myphoto"
    phone_mail "shimokawa@soba-project.com"
    pc_mail "shimokawa@soba-project.com"
    college '蕎麦大学'
    department 'うどん部'
  end
end
