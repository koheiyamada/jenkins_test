module MessageHandler
  def parse_message_params
    message = Message.new(params[:message]) do |m|
      m.sender = current_user
    end
    params[:recipients] ||= {}
    params[:recipients].each do |type, val|
      message.recipients += resolve_recipients(type, val)
    end
    message
  end

  private

    def resolve_recipients(type, val)
      case type
      when "headquarter"
        Headquarter.instance.message_recipients
      when "all_bss"
        Bs.only_active.map(&:message_recipients).flatten
      when "bs"
        Bs.where(id:val).map(&:message_recipients).flatten
      when "my_bs"
        if current_user.organization.is_a?(Bs)
          current_user.organization.message_recipients
        else
          []
        end
      when "all_tutors"
        current_user.tutors
      when "tutor"
        current_user.tutors.where(id:val)
      when "all_students"
        current_user.students
      when "student"
        current_user.students.where(id:val)
      else
        []
      end
    end
end