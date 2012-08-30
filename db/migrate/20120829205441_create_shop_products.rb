class CreateShopProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.string :sku
      t.decimal :price
      t.decimal :old_price
      t.integer :in_stock
      t.integer :category_id

      t.timestamps
    end
    add_index :products, :category_id
  end
end
