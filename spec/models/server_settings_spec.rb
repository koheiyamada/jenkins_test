# cofing:utf-8

require 'spec_helper'

describe ServerSettings do
  describe '.lesson_server_url' do
    it 'http://localhost:8080' do
      ServerSettings.lesson_server_url.should == 'http://localhost:8080'
    end
  end

  describe '.socket_io_url' do
    it 'http://localhost:8080/socket.io/socket.io.js' do
      ServerSettings.socket_io_url.should == 'http://localhost:8080/socket.io/socket.io.js'
    end
  end
end