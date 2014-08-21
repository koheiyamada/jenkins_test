class Tu::MonthlyIncomesController < TutorMonthlyIncomesController
  tutor_only

  prepend_before_filter do
    @tutor = current_user
  end
end
