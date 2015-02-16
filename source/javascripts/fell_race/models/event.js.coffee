class FellRace.Models.Event extends FellRace.Model
  defaults:
    name: 'Event name'
    description: "Description and instructions."
    show_attachments: true
    analytics_id: ""
    date: null
    day: null

  url: =>
    "/api/events/#{@get("slug")}"

  events:
    select: "selectFirstRace"

  initialize: () ->
    super
    @build()
    @wait_then_save = _.debounce @save, 500
    _.each @defaults, (value, key) =>
      @on "change:#{key}", () =>
        @wait_then_save()

  build: =>
    @races = new FellRace.Collections.Races(@get("races"), event: @)
    if @isNew()
      @once "sync", () =>
        @setUrls()
        @races.fetch()
        # if races = @get "races"
        #   @races.reset races
    else
      @setUrls()
      @races.fetch()

  setUrls: =>
    @races.url = "#{@url()}/races"

  toJSON: () =>
    json = 
      event: super

  getMapOptions: =>
    state = {}
    state["center"] = new google.maps.LatLng(@get("map_lat"), @get("map_lng")) if @has("map_lat") and @has("map_lng")
    state["zoom"] = parseInt(@get("map_zoom")) if @has("map_zoom")
    state["mapTypeId"] = @get("map_style") if @has("map_style")
    state

  getPreviewUrl: =>
    "#{@url()}/preview"

  publicUrl: =>
    "/events/#{@get("slug")}"

  editable: =>
    if @has("permissions")
      @get("permissions").can_edit

  createRace: =>
    @races.create name: "Race #{@races.length + 1}"
