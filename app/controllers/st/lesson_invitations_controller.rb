class St::LessonInvitationsController < ApplicationController
  student_only
  layout 'with_sidebar'

  def index
    @lesson_invitations = current_user.lesson_invitations.includes(:lesson).order('lessons.start_time DESC').page(params[:page])
  end

  def show
    @lesson_invitation = current_user.lesson_invitations.find(params[:id])
  end

  # POST lesson_invitations/:id/accept
  def accept
    @lesson_invitation = current_user.lesson_invitations.find(params[:id])
    @lesson_invitation.accept
    if @lesson_invitation.errors.empty?
      redirect_to st_lesson_invitations_path, notice: t('lesson_invitation.accepted')
    else
      render :show
    end
  end

  # POST lesson_invitations/:id/reject
  def reject
    @lesson_invitation = current_user.lesson_invitations.find(params[:id])
    if @lesson_invitation.reject
      redirect_to st_lesson_invitations_path, notice: t('lesson_invitation.rejected')
    else
      render :show
    end
  end
end
