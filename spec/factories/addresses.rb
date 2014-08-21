# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    postal_code1 '604'
    postal_code2 '0873'
    state 'Kyoto'
    line1 'Nakagyo-ku'

    factory :address2 do
      postal_code1 '816'
      postal_code2 '0961'
      state 'Fukuoka'
      line1 'Onojo'
    end

    factory :non_existent_address do
      postal_code1 '123'
      postal_code2 '4567'
      state 'Yamada'
      line1 'hohohohoho'
    end
  end
end
