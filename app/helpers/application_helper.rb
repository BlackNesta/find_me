module ApplicationHelper
  def flash_alert_class(type)
    case type.to_s
    when "alert", "error" then "alert-danger"
    when "notice", "success" then "alert-success"
    else "alert-info"
    end
  end
end
