class FellRace.Models.Route extends Backbone.Model
  defaults:
    name: "route"
    distance: 0
    profile: ""

  initialize: (attributes, options) ->
    @save_soon = _.debounce @save, 1000
    @recalculate_soon = _.debounce @recalculate, 4000

    @on "change:name", (model, val, opts) =>
      @save_soon()
    @on "change:distance", (model, val, opts) =>
      @save_soon()
    @on "change:profile", (model, val, opts) =>
      @save_soon()

    @once "sync", (model) =>
      @points.url = "#{@url()}/points"

    @points = new FellRace.Collections.Points null
    unless @isNew()
      @points.url = "#{@url()}/points"
    @points.add(point) for point in @get('points') if @get("points")

    @listenTo @points, 'change', @pathChange
    @updateProfile() if @points.length and @get('profile') == ""
    $.rte = @

  # toJSON: () =>
  #   json = _.omit(@attributes, 'points')
  #   json['points_attributes'] = @points?.toJSON()# if @isNew()
  #   json

  getPath: =>
    @points.map (pt) ->
      new google.maps.LatLng pt.get("lat"), pt.get("lng")

  # Any change (add/remove/drag) in the points collection will trigger a 'change:path' event
  # that can be picked up in the route_polyline view. Eventually (after a debounce pause) it also
  # causes the recalculation of distance and profile, which in turn triggers a 'change:profile'
  # event that will be picked up in the route_profile view.
  #
  pathChange: ->
    @trigger('change:path')
    @recalculate_soon()

  recalculate: ->
    @calculateDistance()
    @updateProfile()

  calculateDistance: ->
    @set "distance", _.reduce @getPath(), (carry, latlng, i, path) ->
      carry + (path[i+1]?.kmTo(latlng) or 0)
    , 0

  setPoints: (points) =>
    @points.add(point) for point in points

  updateProfile: ->
    es = new google.maps.ElevationService()
    request =
      path: @getPath()
      samples: 475
    es.getElevationAlongPath request, (array, status) =>
      absolute_elevations = _.pluck array, 'elevation'
      base = _.min(absolute_elevations)
      relative_elevations = _.map absolute_elevations, (el) ->
        ~~(el - base)
      @set('profile', relative_elevations.join(','))
