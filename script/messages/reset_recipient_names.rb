ActiveRecord::Base.transaction do
  Message.all.each do |message|
    message.reset_recipient_names
  end
end