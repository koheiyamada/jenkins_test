class StudentMembershipService
  def initialize(student)
    @student = student
  end

  def enrolled_month
    @enrolled_month ||= resolve_enrolled_month
  end

  private

    def resolve_enrolled_month
      t = @student.enrolled_at || @student.created_at
      if t.day <= SystemSettings.cutoff_date
        t.beginning_of_month.to_date
      else
        t.next_month.beginning_of_month.to_date
      end
    end
end