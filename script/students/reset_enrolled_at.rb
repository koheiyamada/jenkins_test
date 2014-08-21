Student.transaction do

  Student.all.each do |student|
    if student.enrolled_at.blank?
      student.enrolled_at = student.created_at
      student.save!
    end
  end

end