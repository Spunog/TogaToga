module ApplicationHelper
	def cp(path,val)
	  val if current_page?(path)
	end

	def current_controller(controller_name,return_value)
	  return_value if controller.controller_name == controller_name
	end

	def if_current_use_class(name,action,val)
	  if name == controller.controller_name && action == controller.action_name
	  	val
	  else
	  	''
	  end
	end
end