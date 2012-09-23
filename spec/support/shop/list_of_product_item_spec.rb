shared_examples "a list of product item" do |editable|
  include ActionView::Helpers

  subject { page }

  it "should contain product picture, link to product and item data" do
    total = 0
    product_items.each_with_index do |product_item, index|
      product = product_item.product
      picture = product.pictures.sort_by{ |p| p.id }.first
      total += product_item.amount
      within "#product_item-#{index}" do
        should have_selector("a[href='#{product_path(product)}']", text: product.name)
        should have_content(number_to_currency(product_item.price))
        should have_content(number_to_currency(product_item.amount))
        if editable.present?
          should have_selector("input[name='cart[product_items_attributes][#{index}][quantity]'][value='#{product_item.quantity}']")
          should have_selector("input[type='checkbox'][name='cart[product_items_attributes][#{index}][_destroy]'][value='1']")
        else
          should have_content(number_to_human(product_item.quantity, units: :product_units, precision: 0))
        end
        should have_selector("img[src='#{picture.image_url(:thumb, :small)}']")
      end
    end
    within ".total_line" do
      should have_content(number_to_currency(total))
    end
  end

end