class CreateRealtyCategories < ActiveRecord::Migration
  def change
    create_table :realty_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
