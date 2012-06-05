class Admin::UsersController < Admin::BaseController
  inherit_resources
  load_and_authorize_resource
end
