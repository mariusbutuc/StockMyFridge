class GroceriesController < ApplicationController
	respond_to :json
	
	def index
=begin
		# The API key must be present and match the key provided by Enthuzr.
		return head(400) if params['api_key'].blank?
		return head(401) if params['api_key'] != API_KEY
		
		# The list of ingredients must be present.
		return head(400) if params['ingredients'].blank?
=end
		
		api_url = 'http://www.techfortesco.com/groceryapi/RESTService.aspx'
		session_key = get_session_key
		products = []
    eclair =
        [
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

		params[:ingredients].each do |i|

      # remove everything that's between parenthesis
      while i.gsub!(/\([^()]*\)/,""); end

      # capture fraction
      # http://stackoverflow.com/questions/245345/regex-to-match-sloppy-fractions-mixed-numbers/245351#245351
      given_amount = i.match('(\d++(?! */))? *-? *(?:(\d+) */ *(\d+))?.*$')

      # convert to float
      integer     = given_amount[1].to_f
      numerator   = given_amount[2].to_f
      denominator = given_amount[3].to_f
      amount = integer + numerator / denominator

      # replace fraction with float
      i.gsub!(/^\d?\s?(\d\/\d)?/, amount.to_s)
      puts i

      amount, unit_of_measurement, fancy_ingredient = i.split(' ', 3)
      ingredient = fancy_ingredient.split(' ').last(2).join(' ')
      if ingredient.blank?
        ingredient = unit_of_measurement
        unit_of_measurement = ''
      end

			res = RestClient.get api_url, {:params => {:command => 'PRODUCTSEARCH', :searchtext => i, :page => 1, :sessionkey => session_key}}
			pro = JSON.parse(res)
			products << { :id => pro['Products'][0]['ProductId'], :name => pro['Products'][0]['Name'], :price => pro['Products'][0]['Price'].exchange('gbp', 'cad') }

      # take quantity
      # multiply by price
      # etc
		end

		respond_with(products)
	end
	
	private
	
	# Login to the system and retrieve the session key.
	def get_session_key
		res = RestClient.get 'https://secure.techfortesco.com/groceryapi_b1/restservice.aspx', {:params => {:command => 'LOGIN', :email => 'bwhtmn@gmail.com', :password => 'stokfridge', :developerkey => 'OULdsDZaBmGE47M7SWK2', :applicationkey => '04291BA250D2B7D6A01D'}}
		res = JSON.parse(res)
		res['SessionKey']
	end
end
