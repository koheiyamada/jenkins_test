class Textbook < ActiveRecord::Base
  include Searchable

  class << self
    def textbook_set_id
      config['textbook_set_id']
    end

    def image_root_url
      config['image_root_url'] % {textbook_set_id: textbook_set_id}
    end

    def image_url_format
      image_root_url + config['textbooks_image_format']
    end

    def answer_book_dir_format
      image_root_url + config['answer_book_dir_format']
    end

    def textbook_dir_format
      image_root_url + config['textbook_dir_format']
    end

    def view_width
      720
    end

    def dir_for_text_id(textbook_id)
      textbook_dir_format % {textbook_id: textbook_id}
    end

    private

      def config
        @config_file ||= YAML.load_file(Rails.root.join(config_file))[Rails.env]
      end

      def config_file
        ENV['TEXTBOOKS_CONFIG'] || 'config/textbooks/textbooks.yml'
      end
  end

  default_scope where(textbook_set_id: textbook_set_id)

  searchable auto_index: false do
    text :title
  end

  ###########################################################################

  attr_accessible :direction, :double_pages, :pages, :title, :textbook_id, :textbook_set_id

  has_one :answer_book

  ###########################################################################

  validates_presence_of :title, :textbook_id, :dir, :height, :width, :textbook_set_id
  validates_inclusion_of :direction, :in => %w(right left)
  validate :dir_exists
  validate :dir_has_images

  before_validation do
    if direction.blank?
      self.direction = 'right'
    end
    if height.blank? || width.blank?
      detect_size_from_image
    end
    if textbook_set_id.blank?
      self.textbook_set_id = Textbook.textbook_set_id
    end
    true
  end

  ###########################################################################

  def image_url(image_no)
    Textbook.image_url_format % {textbook_id:textbook_id, image_no:image_no}
  end

  def images
    (1 .. image_count).map{|i| image_url(i)}
  end

  def image_count
    dir = File.dirname(image_url(1))
    Dir.entries(dir).select{|e| /\.png$/ =~ e}.size
  end

  def view_width
    if portrait?
      Textbook.view_width
    else
      (Textbook.view_width.to_f / height * width).to_i
    end
  end

  def view_height
    if portrait?
      (Textbook.view_width.to_f / width * height).to_i
    else
      800
    end
  end

  def portrait?
    height >= width
  end

  def landscape?
    height < width
  end

  def id_for_user(user)
    "aid-textbook-#{id}-user-#{user.id}"
  end

  def as_json(options)
    options = {
      :methods => [:view_width, :view_height]
    }.merge(options)
    super(options)
  end

  def pages
    Dir.entries(dir).select{|e| /\.png/ =~ e}.size
  end

  def file_path(page)
    "#{dir}/#{page}.png"
  end

  def detect_size
    path = file_path(1)
    if path
      image = Magick::ImageList.new(path)
      self.width = image.columns
      self.height = image.rows
      save
    else
      false
    end
  end

  def answer_book_dir
    self.class.answer_book_dir_format % {textbook_id: textbook_id}
  end

  private

    def dir_exists
      if dir.present? && !Dir.exists?(dir)
        errors.add :dir, :does_not_exist
      end
    end

    def dir_has_images
      if dir.present? && Dir.exists?(dir)
        if pages == 0
          errors.add :dir, :does_not_have_images
        end
      end
    end

    def detect_size_from_image
      path = file_path(1)
      if path && File.exist?(path)
        image = Magick::ImageList.new(path)
        self.width = image.columns
        self.height = image.rows
      end
    end
end
