jQuery ->
	window.LocalNightly = {
		Model: {}
		View: {}
		Collection: {}
		Router: {}
	}

	class LocalNightly.Model.Event extends Backbone.Model

	class LocalNightly.Collection.Events extends Backbone.Collection
		model: LocalNightly.Model.Event
		comparator: (e) ->
			e.get 'start_date'

		curr = new Date()
		todays_date = "#{curr.getFullYear()}-#{curr.getMonth()+1}-#{curr.getDate()}"
		lastweek_date = "#{curr.getFullYear()}-#{curr.getMonth()+1}-#{curr.getDate()+4}"
		
		today: ->
			@filter (event) ->
				(event.get 'start_date') is todays_date
				#(event.get 'start_date') is '2012-05-21'
		next_events: ->
			@filter (event) ->
				(event.get 'start_date') <= lastweek_date

		all_events: ->
			@filter (event) ->
				(event.get 'start_date') != null

	class LocalNightly.Model.Information extends Backbone.Model

	class LocalNightly.View.Master extends Backbone.View
		el: 'body'

		initialize: ->
			$(document).scroll ->
				position = $(document).scrollTop()
				if position isnt 0
					$('#logo').fadeOut('slow')
				else
					$('#logo').fadeIn('slow')
			location = @.options

			events = new LocalNightly.Collection.Events
			events.url = "/api/#{location}"
			events.fetch
				success: =>
					console.log(':)')
					@raw = events
					@render(events)
				error: ->
					console.log ':('
			#events.on 'reset', alert 'adfadsfadfa'
			window.filtered = new LocalNightly.Collection.Events
			
		render: (data) ->
			#container = new LocalNightly.View.Container
			sidebar = new LocalNightly.View.Sidebar collection: data
			mapp = new LocalNightly.View.Map collection: data
		
		today: ->
			filtered.reset(@raw.today())
			@render(filtered)
		next: ->
			filtered.reset(@raw.next_events())
			@render(filtered)
		all: =>
			filtered.reset(@raw.all_events())
			@render(filtered)

		events: 
			'click #today' : 'today'
			'click #next' : 'next'
			'click #all' : 'all'
		
	class LocalNightly.View.DialogBox extends Backbone.View
		el: "#dialog"
		initialize: ->
			console.log('hllo')
			$('#where').change ->
				window.location.href = $(@).val()
	
	###
	class LocalNightly.View.Container extends Backbone.View
		el: '#container'
		initialize: ->
			@render()
		render: ->
			$(@el).empty()
			$(@el).append '<ul></ul>'
			console.log(events)
			events.each (e) =>
				@appendImage e

		appendImage: (event) =>
			image_view = new LocalNightly.View.Image({model: event})
			$('ul').append(image_view.render().el)
	
	class LocalNightly.View.Image extends Backbone.View
		tagName: 'li'

		render: ->
			$(@el).html("<img class='image' src=#{@model.get('picture_url')} />")
			@
		test: ->
			#$(@el).fadeOut()
			console.log('hit')
			height = window.innerHeight || document.body.clientHeight
			console.log height
			$('#fixed').css 'height', height
			$('#fixed').animate
				width: '50%'
				opacity: 1
			, 200, "linear", =>
				@info()
		
		info: ->
			$('#picture').html "<img src=#{@model.get 'picture_url'} />"
			$('#id').html @model.get 'picture_id'
			$('#name').html @model.get 'name'
			$('#startdate').html @model.get 'start_date'
			$('#lat').html @model.get 'latitude'
			$('#long').html @model.get 'longitude'
			$('#link').html "<a href=#{@model.get 'facebook_url'}>link</a>"
			$('#mapview').html "<img src='http://maps.googleapis.com/maps/api/staticmap?center=#{@model.get 'latitude'},#{@model.get 'longitude'}&zoom=14&size=200x200&sensor=false'>"

			information = new LocalNightly.Model.Information
			information.url = @model.get 'facebook_url'
			console.log information.fetch()
			information.fetch
				success: =>
					id = information.get 'venue'
					$('#desc').html information.get 'description'
					$('#venueid').html id['id']
					console.log "https://graph.facebook.com/#{id['id']}"
				error: ->
					console.log ':(('

			$('#fixed').delay(4000).animate {opacity: 0, width:0}

		events:
			'click .image' : 'test'
	###
	
	class LocalNightly.View.Sidebar extends Backbone.View
		el: '#sidebar'
		initialize: ->
			console.log 'sidebar!'
			#$(@el).append "<div id='sideheader'></div>"
			#$(@el).append '<ul></ul>'
			$('#content').html '<ul></ul>'
			#$('ul').hide()
			@render()

		render: ->
			@.collection.each (e) =>
				sidebarlist = new LocalNightly.View.SidebarList({model:e})
				$('ul').append(sidebarlist.render().el)
				
				cond = ->
					console.log $("##{e.cid}").width()
					console.log $("##{e.cid}").height()
					console.log '----'
					if $("##{e.cid}").width() is 200 or 0
						$("##{e.cid}").attr("src", "../images/local.png")
				setTimeout cond, 1000

	class LocalNightly.View.SidebarList extends Backbone.View
		tagName: 'li'
		render: ->
			$(@el).html("<img id=#{@model.cid} class='image' src=#{@model.get('picture_url')} /><br/> #{@model.get('name')}")
			@
		###
		test: =>
			$('#map_header').slideDown()
			$('#map_header #picture').html "<img src=#{@model.get 'picture_url'} />"
			$('#map_header #id').html @model.get 'picture_id'
			$('#map_header #name').html @model.get 'name'

			information = new LocalNightly.Model.Information
			information.url = @model.get 'facebook_url'
			console.log information.fetch()
			information.fetch
				success: =>
					id = information.get 'venue'
					$('#map_header #desc').html information.get 'description'
					$('#map_header #venueid').html id['id']
					console.log "https://graph.facebook.com/#{id['id']}"
				error: ->
					console.log ':(('
		events: 
			'hover .image': 'test'
		###
	class LocalNightly.View.Map extends Backbone.View
		el: '#map_canvas'
		initialize: ->
			myOptions =
				center: new google.maps.LatLng(0, 0)
				zoom: 13
				mapTypeId: google.maps.MapTypeId.ROADMAP

			@map = new google.maps.Map(document.getElementById("map_canvas"), myOptions)
			
			@render()
		render: =>
			console.log 'call'
			@latlngbounds = new google.maps.LatLngBounds()
			@infowindow = new google.maps.InfoWindow
			console.log @.collection
			@.collection.each (e) =>
				latitude = e.get 'latitude'
				longitude = e.get 'longitude'
				#console.log e
				#console.log latitude
				#console.log longitude	
				markerObj = document.getElementById("#{e.cid}")
				contentString = "<img src=#{e.get 'picture_url'} /><br/>
								#{e.get 'name'}<br/>
								#{e.get 'start_date'}"

				marker = new google.maps.Marker
					position: new google.maps.LatLng(latitude, longitude)
					map: @map
					title: e.get 'name'
				
					@latlngbounds.extend new google.maps.LatLng(latitude, longitude)

				google.maps.event.addListener marker, "click", ->
						infowindow.open(@map,@)

				google.maps.event.addDomListener markerObj, "mouseover", =>
					@infowindow.setContent(contentString)
					@infowindow.open(@map, marker)
					@map.panTo marker.getPosition()
			
			@map.fitBounds @latlngbounds
	
	class LocalNightly.Router.Route extends Backbone.Router
		routes :
			"": 'home'
			"nyc": "nyc"
			"lasvegas": "lasvegas"
		home: ->
			dialogbox = new LocalNightly.View.DialogBox
		nyc: ->
			$('#container').hide()
			$('#container').delay(4000).fadeIn('slow')
			container = new LocalNightly.View.Master 'nyc'
		lasvegas: ->
			$('#container').hide()
			$('#container').delay(4000).fadeIn('slow')
			container = new LocalNightly.View.Master 'lasvegas'

	route = new LocalNightly.Router.Route
	#Backbone.history.start()
	Backbone.history.start({pushState: true})