class Home.Models.RacePublication extends Backbone.Model
  initialize: =>
    @on "goTo", () =>
      Home.selected_race = @

  getPath: =>
    if @has "route"
      google.maps.geometry.encoding.decodePath(@get "route")
    else if @has "checkpoint_route"
      google.maps.geometry.encoding.decodePath(@get "checkpoint_route")

  hasRoute: =>
    @has("route") or @has("checkpoint_route")