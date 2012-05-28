class AddUrlUniquenessIndex < ActiveRecord::Migration
  def up
  	add_index :pages, :url, :unique => true
  end

  def down
  	remove_index :pages, :url
  end
end
