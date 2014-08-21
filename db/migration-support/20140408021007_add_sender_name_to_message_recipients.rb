MessageRecipient.scoped.find_each do |mr|
  r = mr.recipient
  m = mr.message
  if m.present?
    s = mr.message.sender
    if s.present?
      mr.sender_name = DisplayNameService.new(r).name_with_role(s)
    else
      mr.sender_name = I18n.t('message_recipient.unknown_sender')
    end
    mr.save!
  else
    mr.destroy
  end
end