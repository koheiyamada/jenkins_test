class RegistrationParentsController < ApplicationController
  layout 'registration'

  def confirm
    if params[:token].blank?
      render :confirmation_error
    else
      @parent_registration_form = ParentRegistrationForm.find_by_confirmation_token(params[:token])
      if @parent_registration_form
        if @parent_registration_form.parent.present?
          render :used
        else
          session[:confirmation_token] = @parent_registration_form.confirmation_token
          redirect_to action:'new'
        end
      else
        render :confirmation_error
      end
    end
  end

  def register_credit_card
    # TODO: redirect to credit card company
    if session[:confirmation_token]
      redirect_to action:"credit_card_registered"
    else
      render template:"register_credit_card_error"
    end
  end

  def credit_card_registered

  end

  def new
    if session[:confirmation_token].blank?
      redirect_to '/confirmation1'
    else
      @parent_registration_form = ParentRegistrationForm.find_by_confirmation_token(session[:confirmation_token])
      if @parent_registration_form.blank?
        redirect_to first_parents_path
      elsif @parent_registration_form.parent.present?
        redirect_to action: 'used'
      else
        @parent = Parent.new do |parent|
          parent.email = @parent_registration_form.email
        end
        @parent.build_address
        @parent_form = ParentEntryForm.new
      end
    end
    question_code = 'reason_to_enroll'
    answer = nil unless defined?(answer)
    answer_options = answer ? answer[:answer_options] : nil
    @question = Question.where(code: question_code).first.answer_options.pluck(:code)
    @free_lesson_limit_number = SystemSettings.free_lesson_limit_number
  end

  def create
    if session[:confirmation_token]
      @parent_registration_form = ParentRegistrationForm.find_by_confirmation_token(session[:confirmation_token])
      params[:parent_registration_form] = @parent_registration_form
      @parent_form = ParentEntryForm.new(params)
      @parent = @parent_form.user
      if @parent_form.save
        # ログインする
        session.delete(:confirmation_token)
        sign_in :user, @parent
        redirect_to action: :show, id: @parent.id
      else
        question_code = 'reason_to_enroll'
        answer = nil unless defined?(answer)
        answer_options = answer ? answer[:answer_options] : nil
        @question = Question.where(code: question_code).first.answer_options.pluck(:code)
        @free_lesson_limit_number = SystemSettings.free_lesson_limit_number
        logger.warn @parent.errors.full_messages
        logger.warn @parent.payment_method.errors.full_messages if @parent.payment_method
        render :new
      end
    else
      redirect_to new_parent_path
    end
  end

  def show
    @parent = current_user
    @free_lesson_limit_number = SystemSettings.free_lesson_limit_number
  end

  def edit
    @parent = current_user
    @parent_form = ParentUpdateForm.new(@parent)
    question_code = 'reason_to_enroll'
    answer = nil unless defined?(answer)
    answer_options = answer ? answer[:answer_options] : nil
    @question = Question.where(code: question_code).first.answer_options.pluck(:code)
    @free_lesson_limit_number = SystemSettings.free_lesson_limit_number
  end

  def update
    @parent = current_user
    @parent_form = ParentUpdateForm.new(@parent)
    if @parent_form.update(params)
      redirect_to action: :show
    else
      render :edit
    end
  end

  def finish
    redirect_to new_pa_payment_path
  end

  def used
    @parent_registration_form = ParentRegistrationForm.find_by_confirmation_token(session[:confirmation_token])
  end
end
