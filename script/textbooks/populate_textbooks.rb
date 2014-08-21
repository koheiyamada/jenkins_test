require 'csv'

TEXTBOOK_SET_ID = (ENV['TEXTBOOK_SET_ID'] || 5).to_i

puts "TEXTBOOK_SET_ID=#{TEXTBOOK_SET_ID}"

new_textbooks = CSV.readlines("db/data/textbooks/textbooks-#{TEXTBOOK_SET_ID}.csv")
new_textbooks.shift
textbooks = new_textbooks.map{|t| {id: t[0].to_i, title: t[1]}}.uniq

textbooks.each do |textbook_data|
  textbook_id = textbook_data[:id]
  title = textbook_data[:title]
  textbook = Textbook.find_by_textbook_id_and_textbook_set_id(textbook_id, TEXTBOOK_SET_ID)
  if textbook.blank?
    textbook = Textbook.new(textbook_id: textbook_id, textbook_set_id: TEXTBOOK_SET_ID)
    puts 'NEW!'
  end
  textbook.title = title
  textbook.dir = Textbook.dir_for_text_id textbook_id
  textbook.detect_size
  if textbook.save
    puts "#{textbook.textbook_id} #{textbook.title} #{textbook.width}x#{textbook.height}"
    if textbook.answer_book.blank?
      puts "Registering the answer book #{textbook.answer_book_dir}"
      textbook.create_answer_book!(dir: textbook.answer_book_dir)
    else
      textbook.answer_book.save!
    end
  else
    puts "Failed to save #{textbook_id}"
    puts textbook.errors.full_messages
  end
end
