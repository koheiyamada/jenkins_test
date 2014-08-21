[HqUser, BsUser, Tutor, Student, Parent].each do |role|
  role.scoped.group_by(&:nickname).each do |nickname, users|
    if nickname.present?
      if users.size > 1
        puts "Duplicate nickname found for #{role.name}: #{nickname}, #{users.map(&:id)}"
        users.each_with_index do |user, i|
          new_nickname = "#{user.nickname}-#{i}"
          user.update_attribute :nickname, new_nickname
          puts "Changed user #{user.id}'s nickname #{nickname} -> #{new_nickname}"
        end
      end
    end
  end
end
