class AddIv < ActiveRecord::Migration
  def change
  	add_column :messages, :iv, :string
  end
end
