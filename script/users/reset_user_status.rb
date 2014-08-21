User.all.each do |user|
  if user.active
    user.status = 'active'
  elsif user.left?
    user.status = 'left'
  elsif user.locked
    user.status = 'locked'
  end

  if user.save
    puts "User #{user.id} becomes #{user.status}."
  else
    puts "User #{user.id} failed to save: #{user.errors.full_messages}"
  end
end
