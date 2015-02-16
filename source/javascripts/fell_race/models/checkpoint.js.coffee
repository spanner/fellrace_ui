class FellRace.Models.Checkpoint extends FellRace.Model
  defaults:
    name: null
    placed: false
    fixed: false
  unsynced: ["colour"]

  initialize: ->
    super
    unless @isNew()
      @placed()

    @on "change:lat", (model, val, opts) =>
      @setGridrefFromLatLng()
      @placed()

    @on "select", @selectRace

    if @race = @collection.race
      @set
        colour: @race.getColour()
        race_selected: @race.selected()
      @listenTo @race, "change:route_colour", @setColourFromRace
      @listenTo @race, "change:selected", @setRaceSelected
    else if @race_publication = @collection.race_publication
      @set
        colour: @race_publication.getColour()
        race_selected: @race_publication.selected()
      @listenTo @race_publication, "change:selected", @setRaceSelected

  setColourFromRace: (model, value, options) =>
    @set colour: value

  selectRace: =>
    @race?.trigger "select"
    @race_publication?.trigger "select"

  setRaceSelected: (model, value, options) =>
    @set race_selected: value

  placed: =>
    @set
      placed: @has('lat') and @has('lng')

  getLatLng: =>
    if @has("lat") and @has("lng")
      new google.maps.LatLng @get("lat"), @get("lng")

  getPubZoom: =>
    @race_publication?.getPubZoom()

  setGridrefFromLatLng: ->
    lat = @get("lat")
    lng = @get("lng")
    if lat and lng
      wgs84 = new LatLon lat, lng
      gb36 = CoordTransform.convertWGS84toOSGB36(wgs84)
      @set gridref: OsGridRef.latLongToOsGrid(gb36).toString(6)
    else
      @set gridref: null

  getColour: =>
    if @has "colour"
      @get "colour"
    else
      @collection.getColour()
