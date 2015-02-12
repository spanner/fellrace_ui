class FellRace.Models.RacePublication extends Backbone.Model
  url: =>
    "/api/races/#{@get("slug")}"

  initialize: ->
    @build()
    @on "select", @select
    @on "deselect", @deselect
    @on "toggle_select", @toggleSelect
    @on "select_publication", @selectPublication

  build: =>
    # @publication = @collection.publication

    @attachments = new FellRace.Collections.Attachments(@get("attachments"), race_publication: @)
    @records = new FellRace.Collections.Records(@get("records"), race_publication: @)
    @instances = new FellRace.Collections.Instances(@get("instances"), race_publication: @)
    @links = new FellRace.Collections.Links(@get("links"), race_publication: @)
    @checkpoints = new FellRace.Collections.Checkpoints(@get("checkpoints"), race_publication: @)
    @checkpoints.sort()

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

  selectPublication: =>
    @publication.trigger "go_to"

  getPubZoom: =>
    @publication?.get "map_zoom"
