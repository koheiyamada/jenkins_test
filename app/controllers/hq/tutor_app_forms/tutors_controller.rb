class Hq::TutorAppForms::TutorsController < TutorsController
  include HqUserAccessControl
  hq_user_only
  access_control
  before_filter :prepare_tutor_app_form
  after_filter :after_create, :only => :create

  def new
    @tutor = @tutor_app_form.new_tutor
  end

  def create
    tutor_form = TutorForm.new(params)
    @tutor = tutor_form.tutor
    if tutor_form.save
      @tutor_app_form.update_column :tutor_id, @tutor.id
      redirect_to action: 'show'
    else
      render :new
    end
  end

  def show
    @tutor = @tutor_app_form.tutor
  end

  private

    def prepare_tutor_app_form
      @tutor_app_form = TutorAppForm.find(params[:tutor_app_form_id])
    end

    def after_create
      if response.status == 302
        if params[:regular]
          @tutor.become_regular!
        end
      end
    end
end
