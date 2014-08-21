Tutor.includes(:info).where(tutor_infos: {special_tutor: true}).each do |tutor|
  if tutor.is_a? SpecialTutor
    puts "Tutor #{tutor.id} is already a SpecialTutor"
  else
    print "Tutor #{tutor.id} is an old special tutor. change to SpecialTutor"
    tutor.become_special_tutor
    new_tutor = Tutor.find(tutor.id)
    if new_tutor.is_a?(SpecialTutor)
      puts '... done.'
    else
      puts '... failed.'
    end
  end
end