class Hq::Students::JournalEntriesController < JournalEntriesController
  hq_user_only
  before_filter :prepare_student

  private

    def subject
      @student
    end
end
