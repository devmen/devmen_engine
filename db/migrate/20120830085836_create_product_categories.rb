class CreateProductCategories < ActiveRecord::Migration
  def change
    create_table :product_categories do |t|
      t.integer :parent_id
      t.string :name
      t.text :description
      t.integer :lft
      t.integer :rgt
      t.integer :depth

      t.timestamps
    end
    add_index :product_categories, :parent_id
    add_index :product_categories, :depth    
    add_index :product_categories, :lft    
    add_index :product_categories, :rgt
  end
end
