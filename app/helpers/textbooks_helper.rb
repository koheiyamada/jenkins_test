module TextbooksHelper
  def textbook_to_json(textbook)
    images_url = images_textbook_url(textbook, format: 'json')
    textbook.as_json(include: :answer_book).merge(images_url: images_url)
  end
end