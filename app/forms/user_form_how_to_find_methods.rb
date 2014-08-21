module UserFormHowToFindMethods
  private

    def load_how_to_find_answer(user)
      @how_to_find_form = HowToFindQuestionForm.find_for_user(user)
      @how_to_find_form && @how_to_find_form.attributes
    end

    def parse_how_to_find_params(params)
      @how_to_find_form = HowToFindQuestionForm.new(user, params[:how_to_find])
      @how_to_find_form.attributes
    end

    def save_how_to_find_answer
      @how_to_find_form.create_answer
    end

    def how_to_find_answer_valid?
      @how_to_find_form.valid?
    end

    def how_to_find_answer_errors
      @how_to_find_form.errors
    end
end