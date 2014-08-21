begin
  Lesson.all.each do |lesson|
    if lesson.friends_lesson?
      puts "Lesson #{lesson.id} is a friends lesson (#{lesson.type})"
      if lesson.friend_id.present?
        puts "  Friend ID: #{lesson.friend_id}"
        if lesson.student_ids.include? lesson.friend_id
          puts "  Friend #{lesson.friend_id} is already a member."
        else
          puts "  Friend #{lesson.friend_id} is not a member."
          lesson_invitation = lesson.invite(lesson.friend)
          if lesson_invitation.persisted?
            puts "    Invited #{lesson.friend_id}"
          else
            puts "    Failed to invited #{lesson.friend_id}: #{lesson_invitation.errors.full_messages}"
          end
        end
      else

      end
    else
      puts "Lesson #{lesson.id} is not (#{lesson.type})"
    end
  end
rescue => e
  puts e.message
end