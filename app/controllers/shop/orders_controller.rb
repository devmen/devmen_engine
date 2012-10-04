class Shop::OrdersController < ApplicationController

  before_filter :check_current_cart

  def new
    @cart = current_cart
    @product_items = @cart.product_items.includes(:product => :pictures)
    @order = ::Shop::Order.new
    if last_order_params
      @order.name = last_order_params[:name]
      @order.email = last_order_params[:email]
      @order.address = last_order_params[:address]
    end
  end

  def create
    @cart = current_cart
    @order = ::Shop::Order.new(params[:order])
    if @order.save
      @order.add(@cart.release)                       # Release cart and move product items to the order
      @order.save(:validate => false)                 # Update the order whithout any validations
      current_cart_destroy                            # Destroy the current cart
      set_last_order_params(@order)                   # Save last order id in a session
      ::Shop::OrderMailer.order_message(@order).deliver     # Send email notification
      flash[:success] = I18n.t('shop.flash.order_is_accepted', default: "Your order has been accepted. Thank you for your purchase!")
      redirect_to root_path
    else
      @product_items = @cart.product_items.includes(:product => :pictures)
      flash.now[:error] = I18n.t('shop.flash.order_creation_failed', default: "Your order was not accepted. Please, check your data.")
      render :new
    end
  end

end
