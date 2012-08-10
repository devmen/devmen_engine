class CreateRealtyPhotos < ActiveRecord::Migration
  def change
    create_table :realty_photos do |t|
      t.integer :entry_id
      t.string :image

      t.timestamps
    end
    add_index :realty_photos, :entry_id
  end
end
