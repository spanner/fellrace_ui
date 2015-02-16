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
    # @wait_then_save = _.debounce @save, 500
    # _.each @defaults, (value, key) =>
    #   @on "change:#{key}", () =>
    #     @wait_then_save()
    @elevator = new google.maps.ElevationService()
    @on "change:encoded_route", @setProfile

  build: =>
    if @collection
      @event = @collection.event
    else if @has("event")
      @event = new FellRace.Models.Event @get("event")
    @attachments = new FellRace.Collections.Attachments(@get("attachments"), race: @)
    @records = new FellRace.Collections.Records(@get("records"), race: @)
    @instances = new FellRace.Collections.Instances(@get("instances"), race: @)
    # @future_instances = new FellRace.Collections.Instances(@instances.future(), race: @)
    # @past_instances = new FellRace.Collections.Instances(@instances.past(), race: @)
    @links = new FellRace.Collections.Links(@get("links"), race: @)
    @checkpoints = new FellRace.Collections.Checkpoints(@get("checkpoints"), race: @)
    @checkpoints.sort()

    # @instances.on "add remove reset", () =>
    #   @future_instances.reset @instances.future()
    #   @past_instances.reset @instances.past()

    # if @isNew()
    #   console.log "is new"
    #   @once "sync", () =>
    #     @setUrls()
    #     if cps = @get "checkpoints"
    #       @checkpoints.reset cps
    # else
    @setUrls()
    @attachments.fetch()
    @checkpoints.fetch()
    @links.fetch()
    @records.fetch()
    @instances.fetch()

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

  preview: =>
    @set preview_json: @jsonForPublication()

  publish: =>
    @set({
      published_json: @jsonForPublication()
      preview_json: null
    }, persistChange: true)

  jsonForPublication: =>
    JSON.stringify
      id: @id
      name: @get("name")
      slug: @get("slug")
      cat: @get("cat")
      climb: @get("climb")
      distance: @get("distance")
      description: @get("description")
      start_time: @get("start_time")
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

  getEvent: =>
    @event

  eventUrl: =>
    @event.publicUrl() if @event

  select: =>
    unless @selected()
      # @collection.deselectAll()
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
