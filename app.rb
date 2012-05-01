require 'sinatra'
require 'slim'
require 'bundler'
require 'httparty'
require 'pp'
Bundler.require

disable :protection

def hello_photos(id)
	api_url = "https://graph.facebook.com/#{id}/photos"
	wall_photos = HTTParty.get(api_url)
	last_week = Time.now - 3*24*60*60

	i = 0

	begin
		j = wall_photos['data'][i]['updated_time'].chomp('+0000')
		l = Time.iso8601(j)
		@k << wall_photos['data'][i]['images'][3]['source']
		i += 1
		puts @k
	end until l < last_week
end

ACCESS_TOKEN = 'AAACEdEose0cBANJfZCZBmZAVydHRkX6BSqwezQDFsDFKEw4VQL47XmDr70ogS5j1aZACDThpbvAzDZAXUbyYKZBQj6Ssg0lv0qzZAjUnTNQlwZDZD'

def event(id)
	event_url = "https://graph.facebook.com/#{id}/events?access_token=#{ACCESS_TOKEN}"
	events_object = HTTParty.get(event_url)
	today = Time.now

	i=0

	begin
		a = Time.iso8601(events_object['data'][i]['start_time'])
		picture_id = events_object['data'][i]['id']
		@k << "https://graph.facebook.com/#{picture_id}/picture?type=large"
		i += 1
		puts picture_id
		puts i
	end until a < today
end

get '/' do
	@k = []
	event('PURELASVEGAS')
	#event('xslasvegas')
	#event('RainLasVegas')
	slim :index
end

get '/las-vegas' do
	@k = []
	event('PURELASVEGAS')
	event('xslasvegas')
	event('RainLasVegas')
	slim :index
end

get '/nyc' do
	@k = []
	event('pachanyc')
	#event('4040Club')
	#event('AmnesiaNYC')
	slim :index
end