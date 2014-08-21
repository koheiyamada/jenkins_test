# coding:utf-8

require 'spec_helper'

describe SystemAdminMailer do
  before(:each) do
    @admin = SystemAdmin.first
  end

  describe 'error_on_charging' do
    it '管理者宛' do
      mail = SystemAdminMailer.error_on_charging 'hello', Exception.new('hoge')
      mail.to.should == [@admin.email]
    end
  end

  describe 'scheduled_job_error_happened' do
    it '管理者宛' do
      mail = SystemAdminMailer.scheduled_job_error_happened 'hello', Exception.new('hoge')
      mail.to.should == [@admin.email]
    end
  end

  describe 'background_job_error' do
    it '管理者宛' do
      mail = SystemAdminMailer.background_job_error 'hello', Exception.new('hoge')
      mail.to.should == [@admin.email]
    end
  end
end
