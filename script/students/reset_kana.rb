ActiveRecord::Base.transaction do
  Student.all.each do |student|
    if student.first_name_kana.blank?
      student.first_name_kana = '-'
    end
    if student.last_name_kana.blank?
      student.last_name_kana = '-'
    end
    student.save
    puts "#{student.id} #{student.full_name_kana}"
  end
end
