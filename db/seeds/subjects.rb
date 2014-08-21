master = YAML.load_file(Rails.root.join('db/data/subjects.yml'))
master['grade_groups'].each do |grade_group_name, subject_names|
  grade_group = GradeGroup.find_or_create_by_name(grade_group_name)
  subject_names.each do |subject_name|
    subject = Subject.find_or_create_by_name(subject_name)
    grade_group.subjects << subject
  end
  grade_group.save!
end
