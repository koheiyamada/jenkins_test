if Textbook.count == 0
  require 'csv'
  CSV.foreach(Rails.root.join('db/data/textbooks/textbooks-4.csv')) do |row|
    textbook_id = row[0].to_i
    title = row[1].split('/').last.chomp
    dir = Textbook.dir_for_text_id textbook_id
    if Textbook.where(textbook_id:textbook_id).empty?
      textbook = Textbook.new do |t|
        t.textbook_id = textbook_id
        t.title = title
        t.dir = dir
      end
      textbook.save!
    end
  end
end
