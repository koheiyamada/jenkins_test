data = YAML.load_file(Rails.root.join('db', 'data', 'operating_systems.yml'))
data.each do |os|
  operating_system = OperatingSystem.where(name: os[:name]).first
  if operating_system
    puts "Updating #{os[:name]}"
    operating_system.update_attributes(os)
  else
    puts "Creating #{os[:name]}"
    OperatingSystem.create!(os)
  end
end
