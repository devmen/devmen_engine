# Include shop module helper to action controller
ActiveSupport.on_load(:application_controller) do
  ApplicationController.class_eval do
    include Shop::Helper
  end  
end