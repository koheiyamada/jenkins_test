class AnswerBook < ActiveRecord::Base

  class << self
    def channel_template
      channel '{{textbook_id}}', '{{user_id}}'
    end

    def channel(textbook_id, user_id)
      "aid-answer-book-#{textbook_id}-user-#{user_id}"
    end
  end

  attr_accessible :textbook, :dir, :height, :width

  belongs_to :textbook

  validates_presence_of :textbook_id, :dir, :height, :width
  validate :dir_exists
  validate :dir_has_images

  before_validation do
    if width.blank? || height.blank?
      detect_size_from_image
    end
    true
  end

  def pages
    Dir.entries(dir).select{|e| /\.png/ =~ e}.size
  end

  def file_path(page)
    "#{dir}/#{page}.png"
  end

  def detect_size
    if detect_size_from_image
      save
    end
  end

  def channel(user)
    AnswerBook.channel(textbook_id, user.id)
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
        true
      else
        false
      end
    end
end
