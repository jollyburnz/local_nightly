require 'sinatra'
require 'slim'
require 'bundler'
require 'httparty'
require 'pp'
Bundler.require

disable :protection

ACCESS_TOKEN = 'AAACEdEose0cBAHo46uzBLMJZAf2zn69tSnj37s1vfQFvPUmEjjBOkt1bi4KOHwYR4CgY1LG76RFKg2MvEXPR3T8AfdAzkjxLcxwHBcAZDZD'

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
	end until l < last_week
end

def event(id)
	event_url = "https://graph.facebook.com/#{id}/events?access_token=#{ACCESS_TOKEN}"
	events_object = HTTParty.get(event_url)
	today = Time.now
	i=0

	begin
		eventModel = {}
		eventModel['start_date'] = Time.iso8601(events_object['data'][i]['start_time'])
		eventModel['picture_id'] = events_object['data'][i]['id']
		eventModel['picture_url'] = "https://graph.facebook.com/#{eventModel['picture_id']}/picture?type=large"
		@k << eventModel
		remaining = events_object['data'].count - i
		i += 1
	end until eventModel['start_date'] < today or remaining == 0
end

get '/' do
	slim :home
end

get '/las-vegas' do
	@k = []
	event('PURELASVEGAS')
	event('xslasvegas')
	event('RainLasVegas')
	@k.to_json
	slim :index
end

get '/api/las-vegas' do
	@k = []
	event('PURELASVEGAS')
	event('xslasvegas')
	event('RainLasVegas')
	@k.to_json
end

get '/nyc' do
	@k = []
	event('pachanyc')
	event('4040Club')
	#event('AmnesiaNYC')
	hello_photos('AmnesiaNYC')
	slim :index
end

