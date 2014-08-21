class InitUsingOperatingSystems < ActiveRecord::Migration
  def up
    User.where('os_id IS NOT NULL').find_each do |u|
      UserOperatingSystem.create do |uos|
        uos.user = u
        uos.operating_system = u.os
        if u.os.unknown?
          uos.build_custom_operating_system(name: u.os.name)
        end
      end
    end
  end

  def down
    UserOperatingSystem.destroy_all
  end
end
