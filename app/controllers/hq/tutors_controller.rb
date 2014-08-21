class Hq::TutorsController < TutorsController
  include TutorSearchable
  hq_user_only
  before_filter :only_readable
  before_filter :only_writable, :except => [:index, :show]

  def index
    if params[:q]
      @tutor_search = TutorSearch.new(params)
      @tutors = @tutor_search.execute
    else
      @tutors = current_user.tutors.only_active.for_list.page(params[:page])
    end
  end

  # GET /hq/ad/tutors/:id/leave
  # POST /hq/ad/tutors/:id/leave
  def leave
    @tutor = Tutor.find_by_id(params[:id])
    if request.post?
      if @tutor
        if @tutor.leave
          redirect_to({action:'index'}, notice:t('messages.tutor_left', tutor:@tutor.full_name))
        end
      else
        redirect_to action:'index'
      end
    end
  end

  def come_back
    @tutor = Tutor.find(params[:id])
    if @tutor.revive.valid?
      redirect_to({action: 'show'}, notice: t('messages.user_revived'))
    else
      render action: 'show'
    end
  end

  def become_regular
    @tutor = Tutor.find_by_id(params[:id])
    if @tutor.beginner?
      @tutor.become_regular!
      redirect_to({action:'show'}, notice:t('messages.tutor_become_regular'))
    else
      redirect_to({action:'show'}, notice:t('messages.tutor_already_regular'))
    end
  end

  def become_beginner
    @tutor = Tutor.find_by_id(params[:id])
    unless @tutor.beginner?
      @tutor.become_beginner
      redirect_to hq_tutor_path(@tutor), notice:t('messages.tutor_become_beginner')
    else
      redirect_to hq_tutor_path(@tutor), notice:t('messages.tutor_already_beginner')
    end
  end

  private

    def only_readable
      unless current_user.can_access?(:tutor, :read)
        redirect_to hq_root_path
      end
    end

    def only_writable
      unless current_user.can_access?(:tutor, :write)
        redirect_to action:"show"
      end
    end

end
