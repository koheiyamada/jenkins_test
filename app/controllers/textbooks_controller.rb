class TextbooksController < ApplicationController
  include TextbooksHelper
  layout 'with_sidebar_expandable'
  before_filter :set_access, :only => [:images, :image]

  def index
    respond_to do |format|
      format.html do
        if params[:q]
          @textbooks = Textbook.search do
            fulltext SearchUtils.normalize_key(params[:q])
          end.results
        else
          @textbooks = Textbook.page(params[:page])
        end
      end
      format.json do
        @textbooks = Textbook.scoped
        render json:@textbooks.as_json
      end
    end
  end

  def show
    @textbook = Textbook.find(params[:id])
    respond_to do |format|
      format.html
      format.json do
        images_url = images_textbook_url(@textbook, format: 'json')
        render json:textbook_to_json(@textbook).as_json.merge(images_url:images_url)
      end
    end
  end

  def image
    @textbook = Textbook.find(params[:id])
    @image_no = params[:page].to_i
    image_url = @textbook.image_url(@image_no)
    respond_to do |format|
      format.html do
        render layout:"plain"
      end
      format.png do
        send_file image_url, :disposition => "inline"
      end
    end
  end

  def images
    @textbook = Textbook.find(params[:id])
    images = (1 .. @textbook.image_count).map{|page| image_textbook_url(format:"png", page:page)}
    render json:{images: images}
  end

  private

    def set_access
      response.headers["Access-Control-Allow-Origin"] = "*"
    end
end
