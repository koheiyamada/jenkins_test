# coding:utf-8
require 'spec_helper'

describe BsAppFormsController do
  describe "POST :create" do
    it "成功する" do
      bs_app_form = {
        :"corporate_name" => "吉本興業",
        :"last_name" => "下川",
        :"first_name" => "拓治",
        :last_name_kana => "しもかわ",
        :first_name_kana => "たくじ",
        :"representative_birthday(1i)"=>"1967",
        :"representative_birthday(2i)"=>"7",
        :"representative_birthday(3i)"=>"1",
        :"representative_sex"=>"male",
        :"phone_number"=>"111-1111-1111",
        :"email"=>"shimokawa@soba-project.com",
        :"email_confirmation"=>"shimokawa@soba-project.com",
        :"reason_for_applying"=>"情熱",
        :"job_history" => "教師",
        :"os_id" => 1,
        :high_school => 'Hoge High School',
        :birth_place => 'Tokyo',
        :driver_license_number => '00000000'
      }
      address = {
        :"postal_code"=>"600-8815",
        :"state"=>"京都府",
        :"line1"=>"京都市下京区中堂寺粟田町",
        :"line2"=>"６号館３階"}
      how_to_find = {
        answer_option: 'search_engine_yahoo'
      }
      reason_to_enroll = {
        answer_options: {'attractive_tutors' => {selected: '1'}}
      }
      post :create,
           'bs_app_form' => bs_app_form,
           'address' => address,
           'how_to_find' => how_to_find,
           'reason_to_enroll' => reason_to_enroll
      p assigns(:bs_app_form).errors.full_messages
      response.should redirect_to(bs_app_form_path(assigns(:bs_app_form)))
    end
  end
end
