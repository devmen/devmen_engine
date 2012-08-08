class CreateContactUsEntries < ActiveRecord::Migration
  def change
    create_table :contact_us_entries do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.text :content

      t.timestamps
    end
  end
end
