class Textbooks::AnswerBooksController < ApplicationController
  include WebApi
  public_api :image, :images
  before_filter :prepare_textbook, :set_access
  layout 'with_sidebar'

  def show
    @answer_book = @textbook.answer_book
    respond_to do |format|
      format.html
      format.json do
        render json:@answer_book.as_json(:methods => [:view_width, :view_height]).merge(images_url:images_textbook_url(@textbook, format: 'json'))
      end
    end
  end

  def lesson_mode
    @answer_book = @textbook.answer_book
    render layout: 'answer_book'
  end

  def image
    @answer_book = @textbook.answer_book
    page = params[:page].to_i
    path = @answer_book.file_path(page)
    respond_to do |format|
      format.html do
        render layout: 'plain'
      end
      format.png do
        send_file path, :disposition => 'inline'
      end
    end
  end

  def images
    @answer_book = @textbook.answer_book
    images = (1 .. @answer_book.pages).map{|page| image_textbook_answer_book_url(format: 'png', page: page)}
    render json:{images: images}
  end

  private

    def prepare_textbook
      @textbook = Textbook.find(params[:textbook_id])
    end

    def set_access
      response.headers["Access-Control-Allow-Origin"] = "*"
    end

end
