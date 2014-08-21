class Gu::WidgetsController < WidgetsController
  private

    def document_camera_channel
      "aid-test-#{Rails.env}-document_camera-#{guest_unique_id}"
    end

    def video_channel
      "aid-test-#{Rails.env}-video-#{guest_unique_id}"
    end

    def guest_unique_id
      session[:guest_unique_id] ||= Array.new(10){charset.sample}.join
    end

    def charset
      @charset ||= ('a'..'z').to_a + ('0'..'9').to_a
    end
end
