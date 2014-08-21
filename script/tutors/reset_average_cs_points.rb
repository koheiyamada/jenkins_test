ActiveRecord::Base.transaction do
  Tutor.all.each do |tutor|
    from = tutor.average_cs_points
    s = TutorCsPointService.new(tutor)
    s.update_average_cs_point!
    puts "id: #{tutor.id}, #{from} => #{tutor.average_cs_points}"
  end
end