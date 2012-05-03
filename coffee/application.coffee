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

	class LocalNightly.View.Master extends Backbone.View
		el: 'body'

		initialize: ->
			$(document).scroll ->
				position = $(document).scrollTop()
				if position isnt 0
					$('#logo').fadeOut('slow')
				else
					$('#logo').fadeIn('slow')
			
			@render()
		render: ->
			console.log('rendered')
			container = new LocalNightly.View.Container
	
	class LocalNightly.View.Container extends Backbone.View
		el: '#container'
		initialize: ->
			window.events = new LocalNightly.Collection.Events
			events.url = '/api/las-vegas'
			events.fetch
				success: =>
					@render()
				error: ->
					console.log ':('
		render: ->
			events.each (e) =>
				console.log e.get 'picture_url'
				$(@el).append("<img src=#{e.get('picture_url')} />")

			
	###
	class LocalNightly.Router.Route extends Backbone.Router
		routes :
			"!/": "home"
			"!/tester": "tester"

		home: ->
			@homeView = new LocalNightly.View.HomeView
			$("#content").html @homeView.el
			console.log(@homeView.el)
		tester: ->
			unless @testView
				@testView = new LocalNightly.View.TestView
			$("#content").html @testView.el
			console.log(@testView.el)
	###

	#route = new LocalNightly.Router.Route
	view = new LocalNightly.View.Master

	#Backbone.history.start()