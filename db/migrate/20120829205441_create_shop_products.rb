class CreateShopProducts < ActiveRecord::Migration
  def change
    create_table :shop_products do |t|
      t.string :name
      t.text :description
      t.string :sku
      t.decimal :price
      t.decimal :old_price
      t.integer :in_stock
      t.integer :category_id

      t.timestamps
    end
    add_index :shop_products, :category_id
  end
end
