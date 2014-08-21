# coding:utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bs_app_form do
    first_name "Takuji"
    last_name "Shimokawa"
    first_name_kana "たくじ"
    last_name_kana "しもかわ"
    corporate_name "下川塾"
    address {Address.create!(postal_code1:"888", postal_code2:"8888", state:'kyoto', line1:"hogehoge")}
    phone_number "1111-1111-1111"
    email "takuji.shiomkawa@gmail.com"
    photo {File.open(Rails.root.join("spec", "fixtures", "files", "photo.gif"))}
    reason_for_applying "MyText"
    job_history "教師"
    os_id 1
    high_school 'Hoge High School'
    birth_place 'Tokyo'
    driver_license_number '00000000'
    representative_sex 'male'
  end
end
