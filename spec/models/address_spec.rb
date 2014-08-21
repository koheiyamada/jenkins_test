# coding:utf-8
require 'spec_helper'

describe Address do
  describe '作成' do
    it '' do
      address = Address.new(postal_code: '123-4567', state: 'Kyoto', line1: 'hoge')
      address.save
      if address.errors.any?
        p address.errors.full_messages
      end
      address.should be_persisted
    end

    it '郵便番号が片方しか与えられていない場合はエラー' do
      address = Address.new(postal_code1: '123', state: 'Kyoto', line1: 'hoge')
      address.should_not be_valid
      address = Address.new(postal_code2: '123', state: 'Kyoto', line1: 'hoge')
      address.should_not be_valid
    end

    it '郵便番号の両方が空であればOK' do
      address = Address.new(postal_code1: '', postal_code2: '', state: 'Kyoto', line1: 'hoge')
      address.should be_valid
    end
  end
end
