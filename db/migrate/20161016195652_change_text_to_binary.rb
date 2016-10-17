class ChangeTextToBinary < ActiveRecord::Migration
  def change
  	change_column :messages, :text, 'binary USING CAST("text" AS binary)'
  end
end
