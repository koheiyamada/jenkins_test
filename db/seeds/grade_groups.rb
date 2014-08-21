if GradeGroup.count == 0
  config = YAML.load_file Rails.root.join('db/data/grade_groups.yml')
  config.each do |group_name, attrs|
    grade_ids = attrs['grade_ids']
    grade_group_order = attrs['grade_group_order']
    group = GradeGroup.find_or_create_by_name group_name
    if group
      grades = Grade.find grade_ids
      group.grades = grades
      group.grade_group_order = grade_group_order
      group.save!
    end
  end
end
