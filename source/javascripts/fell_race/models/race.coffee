class FellRace.Models.Race extends FellRace.Model
  singular_name: 'race'
  savedAttributes: ["name","description","cat","climb","distance",
    "requirements","encoded_route","route_profile","route_colour",
    "route_elevation","shr_id","organiser_name","organiser_email",
    "organiser_phone","organiser_address","picture"
  ]

  toJSON: =>
    json = super
    delete json.race["picture"] unless @get("image_changed")?
    json

  isNew: =>
    !@get("slug")

  url: =>
    "#{_fr.apiUrl()}/races/#{@get("slug")}"

  build: =>
    @attachments = new FellRace.Collections.Attachments(@get("attachments"), race: @)
    @checkpoints = new FellRace.Collections.Checkpoints(@get("checkpoints"), race: @)
    @records = new FellRace.Collections.Records(@get("records"), race: @)
    @links = new FellRace.Collections.Links(@get("links"), race: @)

    _.each ["attachments","checkpoints","records","links"], (collection) =>
      @on "change:#{collection}", (model,data) =>
        @[collection].reset data

    if @isNew()
      @once "sync", () =>
        @setUrls()
    else
      @setUrls()

    @buildInstances()

    @on "select", @select
    @on "deselect", @deselect
    @on "toggle_select", @toggleSelect
    @elevator = new google.maps.ElevationService()
    @on "change:encoded_route", @setProfile

  buildInstances: =>
    @past_instances = new FellRace.Collections.PastInstances [],
      race: @
      url: "#{@url()}/instances"
    @future_instances = new FellRace.Collections.FutureInstances [],
      race: @
      url: "#{@url()}/instances"

    @partitionInstances() if @get("instances")
    @on "change:instances", @partitionInstances

  partitionInstances: =>
    # temporary: compare race date with yesterday so that today's race is in the future
    # TODO: use a proper datetime attribute.
    divider = new Date()#(new Date().getTime() - 24 * 60 * 60 * 1000)
    [past_instances, future_instances] = _.partition @get("instances"), (e) -> new Date(e.date) < divider
    @past_instances.reset past_instances
    @future_instances.reset future_instances

  setUrls: =>
    url_stem = @url()
    @attachments.url = "#{url_stem}/attachments"
    @checkpoints.url = "#{url_stem}/checkpoints"
    @records.url = "#{url_stem}/records"
    @links.url = "#{url_stem}/links"

  getColour: =>
    @get "route_colour"

  getPath: =>
    if encoded_route = @get "encoded_route"
      MapStick.decodePathString(encoded_route)

  setProfile: =>
    path = @getPath() || []
    @log "setProfile", path
    if path.length > 1
      @elevator.getElevationAlongPath(
        {
          path: path
          samples: 256
        }, (results) =>
          total_elevation = 0
          previous_elevation = null
          for point in results
            if previous_elevation
              if previous_elevation < point.elevation
                total_elevation += point.elevation - previous_elevation
            previous_elevation = point.elevation
          @set
            route_profile: results.map((point) -> point.elevation).join()
            route_elevation: Math.round(total_elevation)
      )
    else
      @set
        route_profile: null
        route_elevation: 0

  createRouteFromCheckpoints: =>
    @set encoded_route: MapStick.encodePathString @checkpoints.toGooglePoints()

  getRouteDistance: () =>
    if path = @getPath()
      Math.round(google.maps.geometry.spherical.computeLength(path)/ 1000 * 100) / 100
    else
      0

  publish: =>
    data =
      published_json: @jsonForPublication()
    _fr.broadcast "publishing race"
    $.post "#{@url()}/publish", data, (response) =>
      _fr.navigate("/races/#{@get("slug")}")
    , 'json'

  jsonForPublication: =>
    next_instance = @nextOrRecentInstance()
    JSON.stringify
      id: @id
      date: next_instance?.get("date")
      time: next_instance?.get("time")
      name: @get("name")
      slug: @get("slug")
      cat: @get("cat")
      climb: @get("climb")
      distance: @get("distance")
      description: @get("description")
      colour: @get("route_colour")
      organiser_email: @get("organiser_email")
      organiser_name: @get("organiser_name")
      organiser_address: @get("organiser_address")
      organiser_phone: @get("organiser_phone")
      shr_id: @get("shr_id")
      fb_event_id: @get("fb_event_id")
      twitter_id: @get("twitter_id")
      fra_id: @get("fra_id")
      requirements: @get("requirements")
      route_profile: @get("route_profile")
      route: @get("encoded_route")
      links: @links.map (link) -> link.jsonForPublication()
      records: @records.map (record) -> record.jsonForPublication()
      checkpoints: @checkpoints.map (checkpoint) -> checkpoint.jsonForPublication()
      checkpoint_route: @checkpoints.getEncodedRoute()

  nextOrRecentInstance: =>
    instance = @future_instances.next()
    instance ?= @past_instances.mostRecent()
    instance

  select: =>
    unless @selected()
      @collection.deselectAll()
      @set selected: true

  deselect: =>
    @set selected: false

  toggleSelect: =>
    if @selected()
      @deselect()
    else
      @select()

  selected: =>
    @get "selected"

  getRoute: =>
    @get("encoded_route") || @get("encoded_checkpoint_route")

  getBounds: =>
    if route = @getRoute()
      bounds = new google.maps.LatLngBounds()
      _.each MapStick.decodePathString(route), (point) =>
        bounds.extend point
      bounds
