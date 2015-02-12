class FellRace.Models.Publication extends Backbone.Model

  urlRoot: "/api/publications"

  eventUrl: =>
    "/api/events/#{@get("slug")}"

  url: =>
    url = "/api/publications/#{@get("slug")}"
    if @get("preview") then "#{url}/preview" else url

  initialize: ->
    @build()
    @on 'go_to', @goTo


  getMapOptions: =>
    state = {}
    state["center"] = new google.maps.LatLng(@get("map_lat"), @get("map_lng")) if @has("map_lat") and @has("map_lng")
    state["zoom"] = parseInt(@get("map_zoom")) if @has("map_zoom")
    state["mapTypeId"] = @get("map_style") if @has("map_style")
    state

  getPublishUrl: =>
    "/api/events/#{@get "slug"}/publish"

  editable: =>
    if @has("permissions")
      @get("permissions").can_edit

  build: =>
    @race_publications = new FellRace.Collections.RacePublications(@get("races"), publication:@)
    @selectARace()
    @setEnterable()
    @on "change:races", (model, races, options) =>
      @race_publications.reset races
      @selectARace()
      @setEnterable()

  selectARace: =>
    @race_publications?.selectOne()

  goTo: =>
    _fellrace.navigate "/events/#{@get "slug"}"

  setEnterable: =>
    enterable_instances = []
    @race_publications.each (race) =>
      enterable_instances = enterable_instances.concat race.instances.future()
 
    @enterable_instances = new FellRace.Collections.Instances(enterable_instances)

    @set can_enter: @enterable_instances.length > 0
