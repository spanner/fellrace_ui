class FellRace.Models.Race extends FellRace.Model
  unsynced: ["checkpoints"]
  defaults:
    name: null
    description: null
    requirements: null
    organiser_name: null
    organiser_email: null
    organiser_phone: null
    organiser_address: null
    distance: 0
    climb: 0
    cat: null
    show_attachments: true
    show_checkpoints: true
    show_elevation: true
    show_records: true
    show_links: true
    show_requirements: true
    show_organiser: true
    show_instances: true
    route_colour: "#FF0066"
    show_route: true
    encoded_route: null
    encoded_checkpoint_route: null
    route_profile: null
    route_elevation: null
    start_time: null
    fb_event_id: null
    fra_id: null
    shr_id: null
    twitter_id: null

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
    @records = new FellRace.Collections.Records(@get("records"), race: @)
    @instances = new FellRace.Collections.Instances(@get("instances"), race: @)
    @links = new FellRace.Collections.Links(@get("links"), race: @)
    @checkpoints = new FellRace.Collections.Checkpoints(@get("checkpoints"), race: @)
    @checkpoints.sort()

    _.each ["attachments","checkpoints","records","links","instances"], (collection) =>
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
    @instances.url = "#{url_stem}/instances"
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
    # @save {
    #   published_json: @jsonForPublication()
    #   preview_json: null
    #   },
    #   success: =>
    #     _fellrace.navigate "/races/#{@get("slug")}"

  jsonForPublication: =>
    # instance = @nextOrRecentInstance()
    console.log @nextOrRecentInstance()
    JSON.stringify
      id: @id
      # date: instance?.get("date")
      # start_time: instance?.get("start_time")
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
      fra_id: @get("fra_id")
      shr_id: @get("shr_id")
      fb_event_id: @get("fb_event_id")
      twitter_id: @get("twitter_id")
      requirements: @get("requirements")
      route_profile: @get("route_profile")
      route: @get("encoded_route")
      links: @links.map (link) -> link.jsonForPublication()
      records: @records.map (record) -> record.jsonForPublication()
      checkpoints: @checkpoints.map (checkpoint) -> checkpoint.jsonForPublication()
      checkpoint_route: @checkpoints.getEncodedRoute()

  nextOrRecentInstance: =>
    instance = @instances.next()
    unless instance
      instance = @instances.mostRecent()
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
