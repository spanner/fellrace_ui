class FellRace.Models.RacePublication extends Backbone.Model
  idAttribute: "slug"

  url: =>
    "#{_fellrace.apiUrl()}/race_publications/#{@get("slug")}"

  initialize: ->
    @build()
    @on "select", @select
    @on "deselect", @deselect
    @on "toggle_select", @toggleSelect

  build: =>
    @attachments = new FellRace.Collections.Attachments(@get("attachments")||[])
    @records = new FellRace.Collections.Records(@get("records")||[])
    @links = new FellRace.Collections.Links(@get("links")||[])
    @checkpoints = new FellRace.Collections.PublicCheckpoints(@get("checkpoints")||[], race_publication: this)
    @setUrls()

    @buildInstances()

    _.each ["attachments","checkpoints","records","links"], (collection) =>
      @on "change:#{collection}", (model,data) =>
        @[collection].reset data

  buildInstances: =>
    @past_instances = new FellRace.Collections.PublicPastInstances [],
      race_publication: @
      url: "#{@url()}/instances"
    @future_instances = new FellRace.Collections.PublicFutureInstances [],
      race_publication: @
      url: "#{@url()}/instances"

    @partitionInstances() if @get("instances")
    @on "change:instances", @partitionInstances

  partitionInstances: =>
    [past_instances, future_instances] = _.partition(@get("instances"), (e) -> new Date(e.date) < Date.now())
    @past_instances.reset past_instances
    @future_instances.reset future_instances

  setUrls: =>
    url_stem = @url()
    @attachments.url = "#{url_stem}/attachments"

  select: =>
    unless @selected()
      _fellrace.moveMapTo @
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
    @get("selected")

  getColour: =>
    @get "colour"

  getRoute: =>
    @get("route") || @get("checkpoint_route")

  getBounds: =>
    if route = @getRoute()
      bounds = new google.maps.LatLngBounds()
      _.each MapStick.decodePathString(route), (point) =>
        bounds.extend point
      bounds

  fetchPermissions: =>
    $.getJSON "#{@url()}/permissions", (data) =>
      @set data

  nextOrRecentInstance: =>
    instance = @future_instances.next()
    instance ?= @past_instances.mostRecent()
    instance
