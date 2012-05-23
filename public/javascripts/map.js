// Generated by CoffeeScript 1.3.1
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  jQuery(function() {
    var view;
    window.LocalNightly = {
      Model: {},
      View: {},
      Collection: {},
      Router: {}
    };
    LocalNightly.Model.Event = (function(_super) {

      __extends(Event, _super);

      Event.name = 'Event';

      function Event() {
        return Event.__super__.constructor.apply(this, arguments);
      }

      return Event;

    })(Backbone.Model);
    LocalNightly.Collection.Events = (function(_super) {

      __extends(Events, _super);

      Events.name = 'Events';

      function Events() {
        return Events.__super__.constructor.apply(this, arguments);
      }

      Events.prototype.model = LocalNightly.Model.Event;

      return Events;

    })(Backbone.Collection);
    LocalNightly.View.Map = (function(_super) {

      __extends(Map, _super);

      Map.name = 'Map';

      function Map() {
        this.render = __bind(this.render, this);
        return Map.__super__.constructor.apply(this, arguments);
      }

      Map.prototype.el = 'body';

      Map.prototype.initialize = function() {
        var _this = this;
        this.test = new LocalNightly.Collection.Events;
        this.test.url = "/api/lasvegas";
        return this.test.fetch({
          success: function() {
            console.log(':)');
            return _this.render();
          },
          error: function() {
            return console.log(':(');
          }
        });
      };

      Map.prototype.render = function() {
        var map, myOptions,
          _this = this;
        myOptions = {
          center: new google.maps.LatLng(0, 0),
          zoom: 13,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
        this.latlngbounds = new google.maps.LatLngBounds();
        this.test.each(function(e) {
          var latitude, longitude, marker;
          latitude = e.get('latitude');
          longitude = e.get('longitude');
          marker = new google.maps.Marker({
            position: new google.maps.LatLng(latitude, longitude),
            map: map,
            title: "Hello World!"
          });
          return _this.latlngbounds.extend(new google.maps.LatLng(latitude, longitude));
        });
        console.log(this.latlngbounds);
        return map.fitBounds(this.latlngbounds);
      };

      return Map;

    })(Backbone.View);
    return view = new LocalNightly.View.Map;
  });

}).call(this);
