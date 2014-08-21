# coding:utf-8

class BookRenderer

  class << self
    def view_width
      720
    end
  end

  def initialize(book)
    @book = book
  end

  def width
    if portrait?
      self.class.view_width
    else
      (self.class.view_width.to_f / @book.height * @book.width).to_i
    end
  end

  def height
    if portrait?
      (self.class.view_width.to_f / @book.width * @book.height).to_i
    else
      800
    end
  end

  def portrait?
    @book.height >= @book.width
  end

  def landscape?
    !portrait?
  end

end