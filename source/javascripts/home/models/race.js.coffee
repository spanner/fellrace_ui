class Home.Models.Race extends Backbone.Model

  initialize: =>
    @_event = new Home.Models.Event @get("event")

  eventUrl: =>
    @_event.publicUrl()

  getPath: =>
    if @has "route"
      google.maps.geometry.encoding.decodePath(@get "route")
    else if @has "checkpoint_route"
      google.maps.geometry.encoding.decodePath(@get "checkpoint_route")