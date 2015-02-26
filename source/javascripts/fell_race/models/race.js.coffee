class FellRace.Models.Race extends FellRace.Model
  savedAttributes: ["name","description","cat","climb","distance",
    "requirements","encoded_route","route_profile","route_colour",
    "route_elevation","shr_id","organiser_name","organiser_email",
    "organiser_phone","organiser_address","picture"
  ]

  toJSON: =>
    json = super
    delete json.race["picture"] unless @get("image_changed")?
    json

  url: =>
    "#{_fellrace.apiUrl()}/races/#{@get("slug")}"

  initialize: ->
    super
    @build()
    @on "select", @select
    @on "deselect", @deselect
    @on "toggle_select", @toggleSelect
    @elevator = new google.maps.ElevationService()
    @on "change:encoded_route", @setProfile

  build: =>
    @attachments = new FellRace.Collections.Attachments(@get("attachments"), race: @)
    @checkpoints = new FellRace.Collections.Checkpoints(@get("checkpoints"), race: @)
    @records = new FellRace.Collections.Records(@get("records"), race: @)
    @future_instances = new FellRace.Collections.FutureInstances(@get("future_instances"), race: @)
    @past_instances = new FellRace.Collections.PastInstances(@get("past_instances"), race: @)
    @links = new FellRace.Collections.Links(@get("links"), race: @)

    _.each ["attachments","checkpoints","records","links","past_instances","future_instances"], (collection) =>
      @on "change:#{collection}", (model,data) =>
        @[collection].reset data

    if @isNew()
      @once "sync", () =>
        @setUrls()
    else
      @setUrls()

  isNew: =>
    !@get("slug")

  setUrls: =>
    url_stem = @url()
    @attachments.url = "#{url_stem}/attachments"
    @checkpoints.url = "#{url_stem}/checkpoints"
    @records.url = "#{url_stem}/records"
    @past_instances.url = "#{url_stem}/instances"
    @future_instances.url = "#{url_stem}/instances"
    @links.url = "#{url_stem}/links"

  getColour: =>
    @get "route_colour"

  getPath: =>
    if encoded_route = @get "encoded_route"
      MapStick.decodePathString(encoded_route)

  setProfile: =>
    path = @getPath() || []
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
    $.notify "publishing race"
    $.post "#{@url()}/publish", data, (response) =>
      _fellrace.navigate("/races/#{@get("slug")}")
    , 'json'

  jsonForPublication: =>
    next_instance = @nextOrRecentInstance()
    JSON.stringify
      id: @id
      date: next_instance?.get("date")
      time: next_instance?.get("time")
      online_entry: next_instance?.onlineEntryReady()
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
      # fb_event_id: @get("fb_event_id") #TODO FB page?
      twitter_id: @get("twitter_id")
      requirements: @get("requirements")
      route_profile: @get("route_profile")
      route: @get("encoded_route")
      links: @links.map (link) -> link.jsonForPublication()
      records: @records.map (record) -> record.jsonForPublication()
      checkpoints: @checkpoints.map (checkpoint) -> checkpoint.jsonForPublication()
      checkpoint_route: @checkpoints.getEncodedRoute()

  nextOrRecentInstance: =>
    instance = @future_instances.next()
    instance = @past_instances.mostRecent() unless instance
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
