# coding:utf-8

FactoryGirl.define do
  factory :postal_code do
    prefecture "京都府"
    city "京都市中京区"
    town "少将井御旅町"
    zip_code
    area_code
  end
end
