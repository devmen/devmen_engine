class AddCategoryIdToNews < ActiveRecord::Migration
  def change
    add_column :news, :category_id, :integer
    add_index :news, :category_id
  end
end
