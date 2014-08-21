class ResetTutorAppFormsStatus < ActiveRecord::Migration
  def up
    require Rails.root.join 'script/tutor_app_forms/reset_status'
  end

  def down
  end
end
