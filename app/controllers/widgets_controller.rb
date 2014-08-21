class WidgetsController < ApplicationController
  before_filter :authenticate_user!
  layout 'with_sidebar'

  def video
    @channel = video_channel
  end

  def video_subscriber
    @channel = video_channel
    render layout: false
  end

  def document_camera
    @channel = document_camera_channel
  end

  def document_camera_subscriber
    @channel = document_camera_channel
    render layout: false
  end

  def videos
    @video_channel = video_channel
    @document_camera_channel = document_camera_channel
  end

  private

    def document_camera_channel
      "aid-test-#{Rails.env}-document_camera-#{current_user.id}"
    end

    def video_channel
      "aid-test-#{Rails.env}-video-#{current_user.id}"
    end
end
