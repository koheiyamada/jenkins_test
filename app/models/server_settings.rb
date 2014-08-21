class ServerSettings
  class << self
    def lesson_server_url
      @lesson_server_url = '%{scheme}://%{host}:%{port}' % {scheme: lesson_server_config['scheme'], host:lesson_server_config['host'], port:lesson_server_config['port']}
    end

    def socket_io_url
      @socket_io_url = '%{server}/socket.io/socket.io.js' % {server: lesson_server_url}
    end

    def lesson_server_config
      @lesson_server_config ||= YAML.load_file(Rails.root.join('config', 'lesson_server.yml'))[Rails.env]
    end
  end
end