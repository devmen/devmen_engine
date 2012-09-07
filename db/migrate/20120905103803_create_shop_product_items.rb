class CreateShopProductItems < ActiveRecord::Migration
  def change
    create_table :product_items do |t|
      t.integer :quantity
      t.integer :product_id
      t.integer :cart_id
      t.integer :order_id

      t.timestamps
    end
    add_index :product_items, :product_id
    add_index :product_items, :cart_id    
    add_index :product_items, :order_id    
  end
end
