class Hq::Textbooks::AnswerBooksController < Textbooks::AnswerBooksController
  hq_user_only
  layout 'with_sidebar'

  def show
    @textbook = Textbook.find(params[:textbook_id])
    @answer_book = @textbook.answer_book
  end
end
