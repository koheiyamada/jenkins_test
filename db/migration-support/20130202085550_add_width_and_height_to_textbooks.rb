Textbook.all.each do |textbook|
  path = textbook.images.find{|a| File.exist?(a)}
  img = Magick::ImageList.new(path)
  textbook.width = img.columns
  textbook.height = img.rows
  textbook.save!
end