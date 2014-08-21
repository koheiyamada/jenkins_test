# coding:utf-8
require 'spec_helper'

describe TutorForm do

  let(:other_os) {OperatingSystem.find_by_name('その他')}

  def attrs
    {
      tutor: FactoryGirl.attributes_for(:tutor),
      tutor_info: {
        phone_mail: 'shimokawa@soba-project.com',
        pc_mail: 'shimokiawa@soba-project.com',
        graduated: true,
        college: '蕎麦大学',
        department: 'うどん部',
      },
      tutor_price: {
        hourly_wage: 900
      },
      user_operating_system: {
        operating_system_id: OperatingSystem.first.id,
        custom_os_name: ''
      }
    }
  end

  describe '.create' do
    it 'チューターを作る' do
      tutor_form = TutorForm.new(attrs)
      tutor_form.should be_valid
      tutor_form.tutor.should_not be_a(SpecialTutor)
    end

    it 'special_tutorに1がセットされているとSpecialTutorになる' do
      tutor_form = TutorForm.new(attrs.merge(special_tutor: '1'))
      tutor_form.tutor.should be_a(SpecialTutor)
    end
  end

  it 'user_operating_systemがその他の場合、名前がからだとinvalid' do
    params = attrs.merge(user_operating_system: {operating_system_id: other_os.id, custom_os_name: ''})
    tutor_form = TutorForm.new(params)
    tutor_form.tutor.user_operating_system.should_not be_valid
    tutor_form.tutor.should_not be_valid
    tutor_form.should_not be_valid
  end

  it 'user_operating_systemがその他の場合、CustomOperatingSystemが増える' do
    params = attrs.merge(user_operating_system: {operating_system_id: other_os.id, custom_os_name: 'FreeBSD'})
    tutor_form = TutorForm.new(params)
    expect {
      tutor_form.save.should be_true
    }.to change(CustomOperatingSystem, :count).by(1)
    CustomOperatingSystem.last.name.should == 'FreeBSD'
  end
end