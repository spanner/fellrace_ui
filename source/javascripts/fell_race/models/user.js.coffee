class FellRace.Models.User extends Backbone.Model
  defaults:
    email: ""
    first_name: ""
    last_name: ""
    password: ""
    password_confirmation: ""
    desired_slug: ""
    uid: ""
    authentication_token: ""
    confirmed: false

  urlRoot: =>
    "#{_fellrace.apiUrl()}/users"

  initialize: ->
    @_competitor = new FellRace.Models.Competitor @get("competitor")
    @on "change:competitor", () =>
      @_competitor.set @get("competitor")

  toJSON: () =>
    json =
      user: super

  getCompetitor: =>
    #TODO: reup competitor attributes before entry process begins.
    @_competitor

  hasCompetitor: =>
    !@_competitor?.isNew()

  watchLocation: =>
    if Modernizr.geolocation
      @location_watcher = navigator.geolocation.watchPosition @setLocation, @locationError,
        maximumAge: 60000

  locationError: (error) =>
    console.log "location error", error

  setLocation: (location) =>
    @set
      lat: location.coords.latitude
      lng: location.coords.longitude
