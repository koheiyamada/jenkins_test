ActiveRecord::Base.transaction do
  TeachingSubject.all.each do |ts|
    if ts.tutor.present?
      puts "Tutor:#{ts.tutor_id} Subject:#{ts.subject_id}, Level:#{ts.level}"
      grade_group = ts.grade_group
      subject = grade_group.subjects.where(name: ts.subject.name).first
      if subject.present?
        puts '  Updating teaching subject'
        level = subject.levels.where(level: ts.level).first
        if level.present?
          ts.subject = level.subject
          ts.level = level.level
          ts.subject_level = level
          ts.save!
          puts "    Subject: #{subject.id}, #{subject.name} Level: #{level.code}, #{level.level}"
        else
          puts '    Level not found!'
        end
      else
        puts '  Subject not found!'
      end
    else
      puts "TeachingSubject #{ts.id} does not have tutor_id"
    end
  end
end