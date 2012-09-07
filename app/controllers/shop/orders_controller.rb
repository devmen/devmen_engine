class Shop::OrdersController < InheritedResources::Base

  def new
    @cart = current_cart
    if @cart.product_items.empty?      
      flash[:error] = I18n.t('shop.flash.cart_is_empty', default: "Your cart is empty.")    
      redirect_to cart_path      
    end
    @product_items = @cart.product_items.includes(:product => :pictures)
    @order = ::Shop::Order.new
  end

  def create
    @cart = current_cart
    if @cart.product_items.empty?      
      flash[:error] = I18n.t('shop.flash.cart_is_empty', default: "Your cart is empty.")    
      redirect_to cart_path
      return
    end

    @order = ::Shop::Order.new(params[:order])        
    if @order.save
      @order.add(@cart.release)  # Release cart and move product items to the order
      @order.save(:validate => false)   # Update the order whithout any validations
      current_cart_destroy
      flash[:success] = I18n.t('shop.flash.order_is_accepted', default: "Your order has been accepted. Thank you for your purchase!")    
      redirect_to root_path
    else
      @product_items = @cart.product_items.includes(:product => :pictures)     
      flash.now[:error] = I18n.t('shop.flash.order_creation_failed', default: "Your order was not accepted. Please, check your data.")    
      render :new
    end
  end

end
