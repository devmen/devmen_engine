class CreateShopCategories < ActiveRecord::Migration
  def change
    create_table :shop_categories do |t|
      t.integer :parent_id
      t.string :name
      t.text :description
      t.integer :depth
      t.integer :sort

      t.timestamps
    end
    add_index :shop_categories, :parent_id
  end
end
