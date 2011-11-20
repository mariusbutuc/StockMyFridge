class Ingredient < ActiveRecord::Base
	attr_accessible :amount, :name, :unit
	
	belongs_to :recipe
end
