class FellRace.Models.RacePublication extends Backbone.Model
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
    @future_instances = new FellRace.Collections.PublicFutureInstances(@get("future_instances")||[])
    @past_instances = new FellRace.Collections.PublicPastInstances(@get("past_instances")||[])
    @links = new FellRace.Collections.Links(@get("links")||[])
    @checkpoints = new FellRace.Collections.PublicCheckpoints(@get("checkpoints")||[], race_publication: this)
    @setUrls()

    _.each ["attachments","checkpoints","records","links","past_instances","future_instances"], (collection) =>
      @on "change:#{collection}", (model,data) =>
        @[collection].reset data

  setUrls: =>
    url_stem = @url()
    @attachments.url = "#{url_stem}/attachments"
    @past_instances.url = "#{url_stem}/instances"
    @future_instances.url = "#{url_stem}/instances"

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
