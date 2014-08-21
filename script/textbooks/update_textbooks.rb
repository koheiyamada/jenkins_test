require 'csv'

#new_textbooks = CSV.readlines(Rails.root.join('db/data/textbooks.csv'))
new_textbooks = CSV.readlines('db/data/textbooks.csv')

new_textbooks.each do |textbook_row|
  textbook_id = textbook_row[0].to_i
  textbook = Textbook.find_by_textbook_id_and_textbook_set_id(textbook_id, Textbook.textbook_set_id)
  if textbook.blank?
    textbook = Textbook.new(textbook_id: textbook_id)
  end
  textbook.title = textbook_row[1].split('/').last
  textbook.dir = Textbook.dir_for_text_id textbook_id
  if textbook.save
    puts "#{textbook.width}x#{textbook.height}"
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

#Textbook.all.each do |textbook|
#  if textbook.answer_book.blank?
#    dir = Textbook.answer_book_dir_format % {textbook_id: textbook.textbook_id}
#    answer_book = AnswerBook.create!(textbook:textbook, dir: dir)
#    answer_book.detect_size
#  end
#end