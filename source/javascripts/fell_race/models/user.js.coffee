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

  isPoint: true

  urlRoot: =>
    "#{_fellrace.apiUrl()}/users"

  initialize: ->
    @_competitor = new FellRace.Models.Competitor @get("competitor")
    @on "change:competitor", () =>
      @_competitor.set @get("competitor")
    @set(geo_location: Modernizr.geolocation)

  toJSON: () =>
    json =
      user: super

  getCompetitor: =>
    #TODO: reup competitor attributes before entry process begins.
    @_competitor

  findUserLocation: =>
    if @_watching
      @goTo()
    else
      navigator.geolocation.getCurrentPosition @showPosition, @locationError

  showPosition: (position) =>
    @setLocation position
    @goTo()
    @watchLocation()

  hasCompetitor: =>
    !@_competitor?.isNew()

  watchLocation: =>
    unless @_watching
      @location_watcher = navigator.geolocation.watchPosition @setLocation, @locationError,
        maximumAge: 60000
      @_watching = true

  locationError: (error) =>
    console.log "location error", error

  setLocation: ({coords:coords}={}) =>
    @set
      lat: coords.latitude
      lng: coords.longitude

  getLatLng: =>
    new google.maps.LatLng @get("lat"), @get("lng")

  goTo: =>
    _fellrace.moveMapTo @, 15
