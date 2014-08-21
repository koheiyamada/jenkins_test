Textbook.all.each do |textbook|
  if textbook.answer_book.blank?
    dir = Textbook.answer_book_dir_format % {textbook_id: textbook.textbook_id}
    answer_book = AnswerBook.create!(textbook:textbook, dir: dir)
    answer_book.detect_size
  end
end