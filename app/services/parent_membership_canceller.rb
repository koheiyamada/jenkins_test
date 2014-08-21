class ParentMenbershipCanceller
  def initialize(parent)
    @parent = parent
  end

  def perform
    transaction do
      @parent.student.each do |student|
        student.create_membership_cancellation!
      end
      @parent.create_membership_cancellation!
    end
  end
end
