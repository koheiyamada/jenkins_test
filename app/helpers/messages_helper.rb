module MessagesHelper
  def message_recipient_names(message, max=2)
    message.recipient_names_for(current_user).take(max)
  end

  # 本部へのメール送受信表示は’本部スタッフ’に統一
  def merge_hq_staff_names_of_recipient_for(message, max_show)
    hq_recipients, other_recipients =
    message.recipients.partition{|r| r.type == "HqUser" }

    read_hq_recipients, unread_hq_recipients = hq_recipients.partition do |r|
      mr = message.message_recipients.select(:is_read).
      where(recipient_id: r.id).first
      mr.is_read
    end

    if read_hq_recipients.empty?
      representative_hq = unread_hq_recipients.empty? ? [] :
      unread_hq_recipients
    else
      representative_hq = read_hq_recipients
    end

    merged_recipients = (representative_hq + other_recipients)

    merged_names = []
    # hq 代表
    if representative_hq.size == 1
      merged_names << user_type(representative_hq.first).to_s
    end
    # ほか
    other_recipients.each_with_index do |rpt, i|
      if representative_hq.size + i >= max_show
        merged_names << "..."
        break
      end
      merged_names << ('%s (%s)' % [user_display_name(rpt), user_type(rpt)])
    end

    return [merged_names, merged_recipients.map(&:id).take(max_show)]
  end
end