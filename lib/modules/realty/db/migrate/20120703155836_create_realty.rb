class CreateRealty < ActiveRecord::Migration
  def change
    create_table :realty do |t|
      t.string  :name
      t.integer :price, :null => false, :default => 0
      t.text    :address
      t.text    :description

      t.timestamps
    end
  end
end
