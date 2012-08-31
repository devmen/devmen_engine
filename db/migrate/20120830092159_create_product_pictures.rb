class CreateProductPictures < ActiveRecord::Migration
  def change
    create_table :product_pictures do |t|
      t.string :image
      t.integer :product_id
      t.string :name

      t.timestamps
    end
    add_index :product_pictures, :product_id
  end
end
