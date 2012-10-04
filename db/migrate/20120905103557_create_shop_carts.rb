class CreateShopCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.integer :product_counter

      t.timestamps
    end
  end
end
