class CreateReviewEntries < ActiveRecord::Migration
  def change
    create_table :review_entries do |t|
      t.string :name
      t.text :content
      t.boolean :visible, default: false

      t.timestamps
    end
    add_index :review_entries, :visible
  end
end
