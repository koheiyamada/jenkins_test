[HqUser, BsUser, Tutor, Student, Parent].each do |role|
  role.scoped.group_by(&:nickname).each do |nickname, users|
    if nickname.present?
      if users.size > 1
        puts "Duplicate nickname found for #{role.name}: #{nickname}, #{users.map(&:id)}"
      end
    end
  end
end
