config = YAML.load_file Rails.root.join('db/data/grade_groups.yml')
config.each do |group_name, attrs|
  grade_ids = attrs['grade_ids']
  grade_group_order = attrs['grade_group_order']
  puts "Group name:#{group_name}"
  puts "Group IDs: #{grade_ids}"
  group = GradeGroup.find_or_create_by_name group_name
  if group
    grades = Grade.find grade_ids
    group.grades = grades
    group.grade_group_order = grade_group_order
    group.save!
    puts "Group #{group_name} has #{grades.map(&:id)}. Group order is #{grade_group_order}"
  end
end
