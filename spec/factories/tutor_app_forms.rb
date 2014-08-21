# coding:utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tutor_app_form do
    tutor nil
    first_name "忠太"
    last_name "花京"
    first_name_kana "ちゅうた"
    last_name_kana "かきょう"
    skype_id "tutor_skype_id"
    nickname "chuta"
    phone_number "111-1111-1111"
    phone_mail "shimokawa@soba-project.com"
    pc_mail "shimokawa@soba-project.com"
    current_address {CurrentAddress.create!(postal_code1:"666", postal_code2:"6666", state:'Kyoto', line1:"hogehoge")}
    hometown_address {HometownAddress.create!(postal_code1:"777", postal_code2:"7777", state:'Kyoto', line1:"fugafuga")}
    photo {File.open(Rails.root.join("spec", "fixtures", "files", "photo.gif"))}
    status "new"
    college "京都大学"
    department "工学部"
    grade 1
    year_of_admission 1995
    year_of_graduation 1999
    birth_place "福岡県"
    high_school "筑紫丘高校"
    activities "MyString"
    teaching_experience "MyString"
    free_description "MyString"
    confirmed false
    do_volunteer_work false
    undertake_group_lesson false
    job_history "MyString"
    os_id 1
    driver_license_number '1111111111111111'
    sex 'male'
  end
end
