class DropUserInfos < ActiveRecord::Migration
  def up
    drop_table :user_infos
  end

  def down
    create_table "user_infos", :force => true do |t|
      t.integer  "user_id"
      t.string   "pc_mail"
      t.string   "phone_mail"
      t.string   "first_name"
      t.string   "last_name"
      t.string   "phone_number"
      t.string   "pc_spec"
      t.string   "line_speed"
      t.string   "reference_user_name"
      t.string   "confirmation_token"
      t.datetime "created_at",          :null => false
      t.datetime "updated_at",          :null => false
    end
  end
end
