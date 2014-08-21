module FormsHelper
  def form_has_web_camera(obj)
    if obj.has_web_camera.present?
      t("has_web_camera.#{obj.has_web_camera}")
    end
  end
end