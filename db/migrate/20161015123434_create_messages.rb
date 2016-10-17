class CreateMessages < ActiveRecord::Migration
	def change
		create_table :messages do |t|
			t.text :text
			t.string :del_method
			t.integer :hours
			t.integer :visits

			t.timestamps
		end
	end
end
