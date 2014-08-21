class CreateGuestAccount < ActiveRecord::Migration
  def up
    TrialStudent.create do |s|
      s.user_name = 'guest'
      s.password  = 'password'
    end
  end

  def down
    TrialStudent.destroy_all
  end
end
