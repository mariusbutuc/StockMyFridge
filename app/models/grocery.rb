class Grocery < ActiveRecord::Base
	attr_accessible :calories, :measurement, :name, :price
end
