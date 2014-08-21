class Guest < User
  class << self
    def instance
      Guest.first || Guest.create!(user_name:'guest_user', password:'guest_user_password', email:'shimokawa@soba-project.com')
    end
  end

  def root_path
    gu_root_path
  end
end
