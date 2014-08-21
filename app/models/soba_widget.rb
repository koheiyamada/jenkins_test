class SobaWidget
  class << self
    def app_id
      config["app_id"]
    end

    def host
      config['host']
    end

    def host2
      config['host2']
    end

    def port
      config['port']
    end

    def config
      @config ||= YAML.load_file(Rails.root.join("config", "soba_widgets.yml"))[Rails.env]
    end

    def data_server
      "soba://#{host}/api/server/aid/stream"
    end

    def data_server2
      "soba://#{host2}/api/server/aid/stream"
    end

    def video_publisher_url(channel)
      "//#{host}/apps/#{app_id}/videos/#{channel}/publisher.js"
    end

    def video_subscriber_url(channel)
      "//#{host}/apps/#{app_id}/videos/#{channel}/subscriber.js"
    end

    def document_camera_publisher_url(channel)
      "//#{host2}/apps/#{app_id}/videos/#{channel}/publisher.js"
    end

    def document_camera_subscriber_url(channel)
      "//#{host2}/apps/#{app_id}/videos/#{channel}/subscriber.js"
    end

    def slide_url(channel)
      "//#{host}/apps/#{app_id}/slides/#{channel}/slide.js"
    end

    def scheme
      Rails.env.production? ? 'https' : 'http'
    end

    def meeting_room_channel(meeting, user)
      "aid-meeting-#{meeting.id}-#{user.id}"
    end

    def lesson_materials_channel(lesson, user)
      "aid-lesson-#{lesson.id}-#{user.id}-slide"
    end
  end
end