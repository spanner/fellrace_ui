class Home.Models.Event extends Backbone.Model
  urlRoot: "/api/events"

  publicUrl: =>
    "http://#{@get "slug"}.#{Home.domain()}"
