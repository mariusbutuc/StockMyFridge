class CreateGroceries < ActiveRecord::Migration
	def self.up
		create_table :groceries do |t|
			t.string :name
			t.integer :measurement
			t.integer :price
			t.integer :calories
		end
	end
	
	def self.down
		drop_table :groceries
	end
end
