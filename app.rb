require 'sinatra'
require 'slim'
require 'bundler'
require 'httparty'
require 'json'
Bundler.require

disable :protection

ACCESS_TOKEN = 'AAACEdEose0cBAKBsbH3HpM10ietCv2zfUNBBrFAxWY6FFJdo35CHwBZBzPt2J496xOW0PzZBhpvFJqa16NtPynCfHurFmU8ZCjbjo6vSgZDZD'
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
	map = HTTParty.get("https://graph.facebook.com/#{id}")
	
	#today = Time.now.strftime("%Y-%m-%d %H:%M:%S")
	today = Time.now.strftime("%Y-%m-%d")

	i=0

	while i < events_object['data'].count
		#temp_date = Time.iso8601(events_object['data'][i]['start_time']).strftime("%Y-%m-%d %H:%M:%S")
		temp_date = Time.iso8601(events_object['data'][i]['start_time']).strftime("%Y-%m-%d")
		break if temp_date < today

		eventModel = {}
			#eventModel['start_date'] = Time.iso8601(events_object['data'][i]['start_time']).strftime("%Y-%m-%d %H:%M:%S")
			eventModel['start_date'] = Time.iso8601(events_object['data'][i]['start_time']).strftime("%Y-%-m-%d")
			eventModel['picture_id'] = events_object['data'][i]['id']
			eventModel['name'] = events_object['data'][i]['name']
			eventModel['latitude'] = map['location']['latitude']
			eventModel['longitude'] = map['location']['longitude']
			eventModel['picture_url'] = "https://graph.facebook.com/#{eventModel['picture_id']}/picture?type=large	"
			eventModel['facebook_url'] = "https://graph.facebook.com/#{eventModel['picture_id']}"
			
		@k << eventModel
		i += 1
	end
end

get '/' do
	slim :index
end

get '/map' do
	'hello world'
	slim :map
end

get '/mappp' do
	'hello world'
	slim :map2
end

get '/:location' do
	slim :events
end

get '/api/lasvegas' do
	@k = []
	event('PURELASVEGAS')
	event('xslasvegas')
	event('RainLasVegas')
	@k.to_json
end

get '/api/nyc' do
	@k = []
	event('pachanyc')
	event('4040Club')
	event('AmnesiaNYC')
	event('Webster.Hall.NYC')
	event('santospartyhouse')
	event('lprnyc')
	#hello_photos('AmnesiaNYC')
	@k.to_json
end