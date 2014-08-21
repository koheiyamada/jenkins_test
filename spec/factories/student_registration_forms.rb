# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student_registration_form do
    email 'takuji.shimokawa@gmail.com'
    adsl  false
    confirmation_token 'hogehoge'
    upload_speed 10
    download_speed 20
    os_id 1
    windows_experience_index_score nil
  end
end
