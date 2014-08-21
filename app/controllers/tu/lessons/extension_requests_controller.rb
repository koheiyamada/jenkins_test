class Tu::Lessons::ExtensionRequestsController < ApplicationController
  tutor_only
  before_filter :prepare_lesson

  # このレッスンの延長申込状況を返す。
  # 参加している全受講者の申込情報を取得する。
  # 申込のないものについては空とする
  def index
    @lesson_extension_requests = @lesson.extension_requests
    respond_to do |format|
      format.json do
        render json:@lesson_extension_requests
      end
    end
  end

  # lessons/:id/extension_requests/complete
  # 参加者全員が延長申込をしていればtrueを返す。
  def complete
    result = @lesson.extension_requested_by_all_attended_students?
    respond_to do |format|
      format.json do
        render json:result
      end
    end
  end
end
