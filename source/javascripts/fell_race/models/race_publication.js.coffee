class FellRace.Models.RacePublication extends Backbone.Model
  url: =>
    "#{_fellrace.apiUrl()}/race_publications/#{@get("slug")}"

  initialize: ->
    @build()
    @on "select", @select
    @on "deselect", @deselect
    @on "toggle_select", @toggleSelect
    @on "select_publication", @selectPublication

  build: =>
    @attachments = new FellRace.Collections.Attachments([])
    @records = new FellRace.Collections.Records([])
    @instances = new FellRace.Collections.Instances([])
    @links = new FellRace.Collections.Links([])
    @checkpoints = new FellRace.Collections.Checkpoints([])
    @setUrls()

    _.each ["attachments","checkpoints","records","links","instances"], (collection) =>
      @on "change:#{collection}", (model,data) =>
        @[collection].reset data

  setUrls: =>
    url_stem = @url()
    @attachments.url = "#{url_stem}/attachments"
    @checkpoints.url = "#{url_stem}/checkpoints"
    @records.url = "#{url_stem}/records"
    @instances.url = "#{url_stem}/instances"
    @links.url = "#{url_stem}/links"

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
    @get("selected")

  getColour: =>
    @get "colour"

  hasRoute: =>
    @has("route") or @has("checkpoint_route")
