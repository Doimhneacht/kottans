class ChangeIvToBinary < ActiveRecord::Migration
  def change
  	change_column :messages, :iv, :binary
  end
end
