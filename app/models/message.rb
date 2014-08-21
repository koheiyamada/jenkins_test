# encoding: utf-8
class Message < ActiveRecord::Base
  include UsersHelper
  include TutorsHelper
  STATUS_FOR_SELECT_BOX = [['開封状況', nil], ['未読', false], ['既読', true]]

  class << self
    def for_list
      includes(:sender)
    end

    def for_sent_list
      includes(:recipients)
    end

    def from_tutor
      joins(:sender).where(users: {type: [Tutor.name, SpecialTutor.name]})
    end

    def to_tutor
      joins(:recipients).where(users: {type: [Tutor.name, SpecialTutor.name]})
    end

    def to_users(ids)
      joins(:recipients).where(users: {id: ids})
    end

    def exec_search_by(user, key, options, conditions)
      search = Message.search do
        with :sender_id, user.id
        options.each do |k, v|
          case k
          when :page then paginate page: v, per_page: (options[:per_page] || 25)
          end
        end

        if conditions['is_read'].present?
          with :is_read, conditions['is_read'] == 'false' ? false : true
        end

        recipient_name_field = 'recipient_names_for_'
        recipient_name_field << user.type.underscore
        default_txt_field = [:title, :text]
        fields =  default_txt_field + [recipient_name_field]
        fulltext SearchUtils.normalize_key(key), fields: fields
      end
      search.results
    end

  end

  belongs_to :sender, class_name:User.name
  belongs_to :student
  has_many :message_recipients, :dependent => :destroy
  has_many :recipients, through: :message_recipients, :validate => false
  has_many :message_files
  has_many :user_files, through: :message_files
  belongs_to :original_message, class_name: Message.name
  has_many :replies, class_name: Message.name, foreign_key: :original_message_id

  attr_accessible :text, :title, :recipients, :original_message_id

  validates_presence_of :sender, :title, :text
  validate do
    if recipients.blank?
      errors.add(:recipients, :at_least_one)
    end
  end

  before_save :set_recipient_names

  after_create do
    Mailer.send_mail(:message_created, self)
    logger.message_log("CREATED", attributes)
  end

  searchable auto_index: false do
    integer :sender_id
    boolean :is_read, :multiple => true do
      message_recipients.map(&:is_read)
    end

    text :title
    text :text

    text :recipient_names_for_student
    text :recipient_names_for_tutor
    text :recipient_names_for_parent
    text :recipient_names_for_bs_user
    text :recipient_names_for_hq_user
    text :recipient_names_for_coach

  end

  def recipient_emails
    recipients.map(&:email).compact.uniq
  end

  def reset_recipient_names
    set_recipient_names
    save validate: false
  end

  def recipient_names_for(user)
    s = send("recipient_names_for_#{user.class.name.underscore}")
    s.split("\t")
  rescue Exception => e
    logger.error e
    recipients.map{|r| user_display_name_with_role(r)}
  end

  def recipient_names_for_special_tutor
    recipient_names_for_tutor
  end

  def reply?
    original_message_id.present?
  end

  def can_read?(user)
    if user.hq_user?
      true
    elsif member_ids.include?(user.id)
      # userが送受信者のケース
      true
    else
      # userが送受信者に含まれないケース
      if user.parent?
        (user.student_ids & recipient_ids).present?
      elsif user.bs_user?
        (user.organization.student_ids & member_ids).present?
      else
        false
      end
    end
  end

  def reply_title
    "Re: #{title}"
  end

  def citation_text
    text.split(/\n/).map{|line| "> #{line}"}.join("\n")
  end

  def member_ids
    recipient_ids.push sender_id
  end

  def sender_name_for(user)
    recipient = message_recipient_of_user(user)
    if recipient.present?
      recipient.sender_name
    elsif user.parent?
      recipient = message_recipient_of_user_ids(user.student_ids)
      if recipient.present?
        recipient.sender_name
      end
    end
  end

  def message_recipient_of_user(user)
    message_recipients.where(recipient_id: user.id).first
  end

  def message_recipient_of_user_ids(user_ids)
    message_recipients.where(recipient_id: user_ids).first
  end

  private

    def set_recipient_names
      rs = recipients.take(2)
      self.recipient_names = rs.map{|r| user_display_name_with_role_for_user_type r, HqUser}.join("\t")
      self.recipient_names_for_hq_user = rs.map{|r| user_display_name_with_role_for_user_type r, HqUser}.join("\t")
      self.recipient_names_for_bs_user = rs.map{|r| user_display_name_with_role_for_user_type r, BsUser}.join("\t")
      self.recipient_names_for_coach   = rs.map{|r| user_display_name_with_role_for_user_type r, Coach}.join("\t")
      self.recipient_names_for_tutor   = rs.map{|r| user_display_name_with_role_for_user_type r, Tutor}.join("\t")
      self.recipient_names_for_student = rs.map{|r| user_display_name_with_role_for_user_type r, Student}.join("\t")
      self.recipient_names_for_parent  = rs.map{|r| user_display_name_with_role_for_user_type r, Parent}.join("\t")
    end
end
