User.all.each do |user|
  if user.invalid?
    user.destroy
    puts "#{user.type} #{user.id} was deleted."
  end
end