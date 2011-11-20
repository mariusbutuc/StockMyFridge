class Grocery < ActiveRecord::Base
	attr_accessible :calories, :measurement, :name, :price
	
	def self.convert_to_grams amount, unit
		case unit
			when 'ounce', 'ounces':                   amount * 28.3
#			when 'teaspoon', 'teaspoons', 'tsp':      amount * 4.72
#			when 'tablespoon', 'tablespoons', 'tbsp': amount * 14.373
#			when 'cup', 'cups':                       amount * 186.5
#			when 'pint', 'pt':                        amount * 473
#			when 'gallon', 'gallons':                 amount * 3000
		end
	end
	
	def self.convert_to_ml amount, unit
		case unit
#			when 'ounce', 'ounces':                   amount * 28.3
			when 'teaspoon', 'teaspoons', 'tsp':      amount * 5
			when 'tablespoon', 'tablespoons', 'tbsp': amount * 15
			when 'cup', 'cups':                       amount * 237
			when 'pint', 'pt':                        amount * 473
			when 'gallon', 'gallons':                 amount * 3785
		end
	end
	
	def self.remove_stop_words
		
	end
end
