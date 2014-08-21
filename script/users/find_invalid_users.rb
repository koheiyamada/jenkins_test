User.all.each do |user|
  if user.invalid?
    puts "#{user.type} #{user.id} is invalid because: #{user.errors.full_messages}"
  end
end