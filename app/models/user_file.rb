class UserFile < ActiveRecord::Base
  mount_uploader :file, UserFileUploader

  belongs_to :user
  attr_accessible :file

  before_save :reset_file_size

  # メッセージに添付されたファイルの場合
  has_one :message_file
  has_one :message, through: :message_file

  private

    def reset_file_size
      self.size = file.size if file.present?
    end
end
