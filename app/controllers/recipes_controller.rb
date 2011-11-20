class RecipesController < ApplicationController
	respond_to :html, :json
  
  def index
    @recipes = Recipe.all
  end
	
	def show
		@recipe = Recipe.find(params[:id])
	end
	
	def create
=begin
		# The API key must be present and match the key provided by Enthuzr.
		return head(400) if params['api_key'].blank?
		return head(401) if params['api_key'] != API_KEY
		
		# The list of ingredients must be present.
		return head(400) if params['ingredients'].blank?
=end
		
		api_url = 'http://www.techfortesco.com/groceryapi/RESTService.aspx'
		session_key = get_session_key
		@products = []
		
=begin
		eclair = [
			"1/2 cup butter                                 ",
			"1 cup water                                    ",
			"1 cup all-purpose flour                        ",
			"1/4 teaspoon salt                              ",
			"4 eggs                                         ",
			"1 (5 ounce) package instant vanilla pudding mix",
			"2 1/2 cups cold milk                           ",
			"1 cup heavy cream                              ",
			"1/4 cup confectioners' sugar                   ",
			"1 teaspoon vanilla extract                     ",
			"2 (1 ounce) squares semisweet chocolate        ",
			"2 tablespoons butter                           ",
			"1 cup confectioners' sugar                     ",
			"1 teaspoon vanilla extract                     ",
			"3 tablespoons hot water                        "
		]
		params[:ingredients] = eclair
=end
		
		@recipe = Recipe.create(:name => params[:name])
		
		params[:ingredients].each do |i|
			# remove everything that's between parenthesis
			while i.gsub!(/\([^()]*\)/,""); end
			
			# capture fraction
			# http://stackoverflow.com/questions/245345/regex-to-match-sloppy-fractions-mixed-numbers/245351#245351
			given_amount = i.match('^(\d+(?! */))? *-? *(?:(\d+) */ *(\d+))?')
			
			# convert to float
			integer     = given_amount[1].to_f
			numerator   = given_amount[2].to_f
			denominator = given_amount[3].to_f
			denominator = 1 if denominator == 0
			amount = integer + numerator / denominator
			
			# replace fraction with float
			i.gsub!(/^(\d+(?! *\/))? *-? *(?:(\d+) *\/ *(\d+)\s*)?/, '')
			
			unit_of_measurement, fancy_ingredient = i.split(' ', 2)
			
			if fancy_ingredient.blank?
				ingredient = unit_of_measurement
				unit_of_measurement = ''
			else
				ingredient = fancy_ingredient.split(' ').last(2).join(' ')
			end
			
			logger.info "Ingredient: amount = #{amount}; unit = #{unit_of_measurement}; name = #{ingredient}"
			
			# Create the ingredient and attach it to the recipe.
			@recipe.ingredients.create(:amount => amount, :name => i)
			
			res = RestClient.get api_url, {:params => {:command => 'PRODUCTSEARCH', :searchtext => ingredient, :page => 1, :sessionkey => session_key}}
			pro = JSON.parse(res)
			
			# Skip this ingredient if nothing could be found.
			next if pro['Products'].blank?
			
			@products << { :id => pro['Products'][0]['ProductId'], :name => pro['Products'][0]['Name'], :price => pro['Products'][0]['Price'].exchange('gbp', 'cad'), :image => pro['Products'][0]['ImagePath'] }
		end
		
		respond_with(@products) do |format|
			format.html { render :partial => 'recipe' }
		end
	end
	
	private
	
	# Login to the system and retrieve the session key.
	def get_session_key
		res = RestClient.get 'https://secure.techfortesco.com/groceryapi_b1/restservice.aspx', {:params => {:command => 'LOGIN', :email => 'bwhtmn@gmail.com', :password => 'stokfridge', :developerkey => 'OULdsDZaBmGE47M7SWK2', :applicationkey => '04291BA250D2B7D6A01D'}}
		res = JSON.parse(res)
		res['SessionKey']
	end
end
