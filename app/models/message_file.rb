class MessageFile < ActiveRecord::Base
  belongs_to :user_file
  belongs_to :message
end
