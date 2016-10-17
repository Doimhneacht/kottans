class ChangeIvToBinary < ActiveRecord::Migration
  def change
  	change_column :messages, :iv, 'bytea USING CAST("iv" AS bytea)'
  end
end
