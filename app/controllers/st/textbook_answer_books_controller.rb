class St::TextbookAnswerBooksController < Textbooks::AnswerBooksController
  student_only
  layout 'with_sidebar'

  def show
    @textbook = Textbook.find(params[:textbook_id])
    @answer_book = @textbook.answer_book
  end
end
