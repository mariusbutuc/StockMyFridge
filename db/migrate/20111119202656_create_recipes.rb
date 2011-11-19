class CreateRecipes < ActiveRecord::Migration
	def self.up
		create_table :recipes do |t|
			t.string :name
			t.text :description
			t.text :directions
			t.float :cooking_time
			t.float :ready_in
			t.integer :number_of_servings
			t.integer :calories
			t.float :fat
			t.integer :cholesterol
			t.timestamps
		end
	end
	
	def self.down
		drop_table :recipes
	end
end
