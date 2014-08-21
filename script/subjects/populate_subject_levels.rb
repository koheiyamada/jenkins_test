data = YAML.load_file Rails.root.join('db/data/subject_levels.yml')

ActiveRecord::Base.transaction do
  GradeGroup.all.each do |group|
    subjects = data[group.name]
    subjects.each do |name, subject_attrs|
      subject = group.subjects.where(name: name).first
      if subject.blank?
        puts "Creating a new subject #{name} for group #{group.name}"
        subject = group.subjects.create!(name: name)
      end
      if subject.levels.empty?
        levels = subject_attrs[:levels]
        levels.each do |code, attrs|
          puts "Creating subject level #{code}:#{attrs[:level]} to #{group.name}:#{subject.name}"
          subject.levels.create! code: code, level: attrs[:level]
        end
      else
        puts "Subject #{subject.id} already has levels."
      end
    end
  end
end
