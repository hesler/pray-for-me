module ApplicationHelper
  def in_controller(controller_name)
    controller.controller_name == controller_name
  end

  def in_action(controller_name, action_name)
    in_controller(controller_name) && (controller.action_name == action_name)
  end

  def in_flash_error(field)
    flash[:error] && (flash[:error].messages.keys.include? field)
  end
end
