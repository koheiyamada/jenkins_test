class St::SettingsController < ApplicationController
  include StudentAccessControl
  student_only
  layout 'with_sidebar'

  def show
  end
end
