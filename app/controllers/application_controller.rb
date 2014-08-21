# coding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :log_access
  before_filter :update_current_user_timezone
  around_filter :in_user_timezone
  after_filter  :update_last_request_at

  # Definitions of access controll methods
  class << self
    User.subclasses.each do |type|
      name = type.underscore
      define_method name + "_only" do
        before_filter do
          authenticate_user!
        end
        before_filter do
          unless current_user.send name + "?"
            redirect_to new_user_session_path
          end
        end
      end
    end

    def block_user_type(user_type, options={})
      before_filter options do
        if current_user.is_a? user_type
          redirect_to root_path
        end
      end
    end

    def block_coach(options={})
      block_user_type Coach, options
    end

    def need_ready_to_pay(options={})
      options = {
        url: root_url,
        error_message: t('message.not_ready_to_pay')
      }.merge(options)
      if user_signed_in?
        unless current_user.ready_to_pay?
          redirect_to options[:url], alert:options[:error_message]
        end
      end
    end
  end

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception do |error|
      render_error 500, error
    end
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound do |error|
      render_error 404, error
    end
  end
    
  private

    def render_error(status, error)
      logger.error "path:#{request.fullpath}\tclass:#{error.class}\tmessage:#{error.message}\tbacktrace:#{error.backtrace.join(', ')}"
      SystemAdminMailer.error_happened(request, status, error, current_user).deliver
      respond_to do |format|
        format.html { render template: "errors/error_#{status}", layout: 'layouts/errors', status: status }
        format.all { render nothing: true, status: status }
      end
    end

    def prepare_student
      @student = Student.find(params[:student_id])
    end

    def prepare_tutor
      @tutor = Tutor.find(params[:tutor_id]) if params[:tutor_id]
    end

    def prepare_bs
      @bs = Bs.find(params[:bs_id]) if params[:bs_id]
    end

    def prepare_lesson
      @lesson = Lesson.find_by_id(params[:lesson_id]) if params[:lesson_id]
    end

    def update_last_request_at
      if user_signed_in?
        current_user.touch :last_request_at unless request.xhr?
      end
    end

    def log_access
      logger.info('ACCESS TO %s by %s' % [request.path, user_signed_in? ? current_user.user_name : '<anonymous>'])
    end

    def development_only
      unless Rails.env.development?
        redirect_to root_path
      end
    end

    def update_current_user_timezone
      timezone = cookies[:timezone]
      if timezone.present? && user_signed_in? && current_user.timezone != timezone
        current_user.update_column :timezone, timezone
      end
    end


    def in_user_timezone
      old_timezone = Time.zone
      set_user_timezone
      yield
    ensure
      Time.zone = old_timezone
    end

    def set_user_timezone
      if user_signed_in?
        Time.zone = user_timezone
      end
    rescue => e
      logger.error e
      logger.error "Failed to detect the user time zone from '#{user_timezone}'"
    end

    def user_timezone
      cookies[:timezone] || current_user.timezone || Time.zone
    end
end
