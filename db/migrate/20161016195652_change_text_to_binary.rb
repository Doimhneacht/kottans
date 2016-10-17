class ChangeTextToBinary < ActiveRecord::Migration
  def change
  	change_column :messages, :text, :binary
  end
end
