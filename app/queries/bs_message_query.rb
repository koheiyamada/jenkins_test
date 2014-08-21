class BsMessageQuery
  def initialize(bs_user)
    @bs_user = bs_user
  end

  attr_reader :bs_user

  def messages_to_students_from_tutors
    student_ids = bs_user.students.pluck(:id)
    Message.from_tutor.joins(:message_recipients).where(message_recipients: {recipient_id: student_ids})
  end

  def messages_between_students_and_tutors
    student_ids = bs_user.students.pluck(:id)
    messages_between_users_and_tutors(student_ids)
  end

  def messages_between_student_and_tutors(student)
    messages_between_users_and_tutors(student.id)
  end

  def coach_messages(coach)
    coach_messages_query coach.id
  end

  def all_coach_messages
    user_ids = bs_user.organization.coach_ids
    coach_messages_query user_ids
  end

  private

    def messages_between_users_and_tutors(user_ids)
      tutor_types = [Tutor.name, SpecialTutor.name]
      Message.joins(:sender, :recipients)
      .where(
        '(users.type IN (:tutor_types) AND message_recipients.recipient_id IN (:user_ids)) OR '\
        '(users.id IN (:user_ids))',
        tutor_types: tutor_types,
        user_ids: user_ids
      )
      .group('messages.id')
      .having(
        '(sum(recipients_messages.type = "HqUser") = 0) AND ' \
        '(sum((users.id NOT IN (:user_ids)) OR ' \
             '(users.id IN (:user_ids) AND recipients_messages.type IN (:tutor_types))) > 0)',
        tutor_types: tutor_types,
        user_ids: user_ids
      )
      .order('messages.created_at DESC')
    end

    def coach_messages_query(user_ids)
      hq_user_types = [HqUser.name]
      Message.joins(:sender, :recipients)
      .where(
        '(users.type NOT IN (:hq_user_types) AND message_recipients.recipient_id IN (:user_ids)) OR '\
        '(users.id IN (:user_ids))',
        hq_user_types: hq_user_types,
        user_ids: user_ids
      )
      .group('messages.id')
      .having('(sum(recipients_messages.type = "HqUser") = 0)')
      .order('messages.created_at DESC')
    end
end