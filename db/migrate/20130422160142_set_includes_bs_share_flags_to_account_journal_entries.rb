class SetIncludesBsShareFlagsToAccountJournalEntries < ActiveRecord::Migration
  def up
    Account::OptionalLessonFee.all.each do |entry|
      if entry.lesson
        if entry.lesson.tutor
          if entry.lesson.tutor.regular?
            if entry.update_attribute :includes_bs_share, true
              puts "#{entry.id} #{entry.lesson.id}"
            end
          end
        end
      end
    end

    Account::BasicLessonFee.all.each do |entry|
      if entry.lesson
        if entry.lesson.tutor
          if entry.lesson.tutor.regular?
            if entry.update_attribute :includes_bs_share, true
              puts "#{entry.id} #{entry.lesson.id}"
            end
          end
        end
      end
    end
  end

  def down
  end
end
