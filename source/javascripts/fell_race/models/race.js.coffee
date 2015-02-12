class FellRace.Models.Race extends Backbone.Model
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
    "/api/races/#{@get("slug")}"

  initialize: ->
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

    if @isNew()
      @once "sync", () =>
        @setUrls()
        if cps = @get "checkpoints"
          @checkpoints.reset cps
    else
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

  toJSON: () =>
    json =
      race: super

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
