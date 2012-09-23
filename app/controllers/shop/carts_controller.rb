class Shop::CartsController < ApplicationController

  before_filter :check_current_cart, :only => :show

  def show
    @cart = current_cart
    @product_items = @cart.product_items.includes(:product => :pictures)
  end

  def update
    @cart = current_cart
    is_updated = @cart.update_attributes(params[:cart])
    respond_to do |format|
      format.html { set_flash_and_respond(is_updated) }
      format.js { set_flash_and_respond(is_updated, :js) }
    end
  end

  private

    def set_flash_and_respond(success, format = :html)
      if success
        if params[:button] == 'update'
          unless @cart.product_items.empty?
            flash.now[:success] = I18n.t('shop.flash.cart_is_updated', default: "Your cart has been successfully updated.")
            render :show
          else
            flash[:success] = I18n.t('shop.flash.cart_is_cleared', default: "Your cart has been cleared.")
            redirect_to root_path if format == :html
            render js: "window.location.pathname = '#{root_path}'" if format == :js
          end
        elsif params[:button] == 'checkout'
          redirect_to new_order_path if format == :html
          render js: "window.location.pathname = '#{new_order_path}'" if format == :js
        end
      else
        flash[:error] = I18n.t('shop.flash.cart_update_failed', default: "Your cart updated failed.")
        render :show
      end
    end

end
