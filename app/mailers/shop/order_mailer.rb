class Shop::OrderMailer < ActionMailer::Base
  helper :application, ::Shop::Helper

  default from: CFG['shop']['email']

  def order_message(order)
    @order = order
    @product_items = @order.product_items
    subject = I18n.t('order_mail_message', default: "Order number #{order.num}", :num => order.num)
    mail(to: order.email, subject: subject)
  end
end
