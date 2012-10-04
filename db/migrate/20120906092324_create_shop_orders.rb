class CreateShopOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name
      t.string :email
      t.text :address
      t.string :num

      t.timestamps
    end
  end
end
