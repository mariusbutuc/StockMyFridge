class Recipe < ActiveRecord::Base
	attr_accessible :calories, :cholesterol, :cooking_time, :description, :directions, :fat, :name, :number_of_servings, :ready_in
  
  has_many :ingredients
end
