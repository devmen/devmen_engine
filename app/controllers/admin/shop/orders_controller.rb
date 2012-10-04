class Admin::Shop::OrdersController < Admin::BaseController
  inherit_resources
  defaults resource_class: ::Shop::Order, collection_name: "orders", instance_name: "order"

end
