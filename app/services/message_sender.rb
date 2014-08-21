# coding:utf-8

class MessageSender
  include Loggable

  def initialize(sender, recipients, message_params)
    @message = Message.new(message_params) do |m|
      m.sender = sender
    end
    recipients ||= {}
    recipients.each do |type, val|
      @message.recipients += resolve_recipients(type, val, sender)
    end
  end

  attr_reader :message

  def send
    @message.save
  end

  private

    def resolve_recipients(type, val, sender)
      logger.debug "type=#{type}, val=#{val}"
      case type
      when 'headquarter'
        Headquarter.instance.message_recipients
      when 'hq_user'
        HqUser.where(id: val)
      when 'all_bss'
        Bs.only_active.map(&:message_recipients).flatten
      when 'bs'
        Bs.where(id:val).map(&:message_recipients).flatten
      when 'bs_user'
        BsUser.where(id:val)
      when 'coach'
        Coach.where(id:val)
      when 'my_bs'
        if sender.organization.is_a?(Bs)
          sender.organization.message_recipients
        else
          []
        end
      when 'all_tutors'
        sender.active_tutors
      when 'tutor'
        sender.tutors.where(id:val)
      when 'special_tutor'
        sender.tutors.where(id:val)
      when 'all_students'
        sender.active_students
      when 'student'
        students(val, sender)
      when 'all_parents'
        sender.active_parents
      when 'parent'
        sender.parents.where(id:val)
      else
        []
      end
    end

    def students(ids, sender)
      if message.reply?
        # 返信メッセージの場合は送信可能な相手を制限しない。
        Student.where(id: ids)
      else
        sender.students.where(id: ids)
      end
    end
end