class ChangeTextToBinary < ActiveRecord::Migration
  def change
  	change_column :messages, :text, 'bytea USING CAST("text" AS bytea)'
  end
end
