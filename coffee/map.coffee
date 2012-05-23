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
		
	class LocalNightly.View.Map extends Backbone.View
		el: 'body'
		initialize: ->
			@test = new LocalNightly.Collection.Events
			@test.url = "/api/lasvegas"
			@test.fetch
				success: =>
					console.log(':)')
					@render()
				error: ->
					console.log ':('
			
		render: =>
			myOptions =
				center: new google.maps.LatLng(0, 0)
				zoom: 13
				mapTypeId: google.maps.MapTypeId.ROADMAP

			map = new google.maps.Map(document.getElementById("map_canvas"), myOptions)
			
			@latlngbounds = new google.maps.LatLngBounds()

			@test.each (e) =>
				latitude = e.get 'latitude'
				longitude = e.get 'longitude'

				marker = new google.maps.Marker
					position: new google.maps.LatLng(latitude, longitude)
					map: map
					title: "Hello World!"
				
				@latlngbounds.extend new google.maps.LatLng(latitude, longitude)
				#marker.setMap(map)
			console.log(@latlngbounds)
			
			map.fitBounds( @latlngbounds )

	view = new LocalNightly.View.Map