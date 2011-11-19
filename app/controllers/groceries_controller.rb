class GroceriesController < ApplicationController
	respond_to :json
	
	def index
		# The API key must be present and match the key provided by Enthuzr.
		return head(400) if params['apiKey'].blank?
		return head(401) if params['apiKey'] != API_KEY
		
		# The list of ingredients must be present.
		return head(400) if params['ingredients'].blank?
		
		api_url = 'http://www.techfortesco.com/groceryapi/RESTService.aspx'
		session_key = get_session_key
		products = []
		
		params[:ingredients].each do |i|
			res = RestClient.get api_url, {:params => {:command => 'PRODUCTSEARCH', :searchtext => i, :page => 1, :sessionkey => session_key}}
			pro = JSON.parse(res)
			products << { :id => pro['Products'][0]['ProductId'], :name => pro['Products'][0]['Name'], :price => pro['Products'][0]['Price'].exchange('gbp', 'cad') }
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
