class AddPriceColumnsToProductItems < ActiveRecord::Migration
  def change
    add_column :product_items, :price, :decimal, :precision => 10, :scale => 2
    add_column :product_items, :amount, :decimal, :precision => 10, :scale => 2
  end
end
