class AddCategoryIdToRealty < ActiveRecord::Migration
  def change
    add_column :realty, :category_id, :integer
    add_index :realty, :category_id
  end
end
