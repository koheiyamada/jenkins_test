Tutor.all.each do |tutor|
  if tutor.price.blank?
    tutor.price = TutorPrice.new_default_price
  end
end
