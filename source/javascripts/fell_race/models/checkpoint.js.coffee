class FellRace.Models.Checkpoint extends FellRace.Model
  initialize: ->
    super
    unless @isNew()
      @placed()

    @on "change:lat", (model, val, opts) =>
      @placed()
      @setGridrefFromLatLng(opts)

    if @race = @collection.race
      @set
        colour: @race.getColour()
        race_selected: @race.selected()
      @listenTo @race, "change:route_colour", @setColourFromRace
    else if @race_publication = @collection.race_publication
      @set
        colour: @race_publication.getColour()
        race_selected: @race_publication.selected()
      @listenTo @race_publication, "change:selected", @setRaceSelected

  setColourFromRace: (model, value, options) =>
    @set colour: value

  placed: =>
    @set placed: @has('lat') and @has('lng')

  getLatLng: =>
    if @has("lat") and @has("lng")
      new google.maps.LatLng @get("lat"), @get("lng")

  getPubZoom: =>
    @race_publication?.getPubZoom()

  setGridrefFromLatLng: (opts) ->
    lat = @get("lat")
    lng = @get("lng")
    if lat and lng
      wgs84 = new LatLon lat, lng
      gb36 = CoordTransform.convertWGS84toOSGB36(wgs84)
      @set gridref: OsGridRef.latLongToOsGrid(gb36).toString(6), opts
    else
      @set(gridref: null, opts)

  getColour: =>
    if @has "colour"
      @get "colour"
    else
      @collection.getColour()

  jsonForPublication: =>
    pos: @get("pos")
    name: @get("name")
    lat: @get("lat")
    lng: @get("lng")
    gridref: @get("gridref")
    fixed: @get("fixed")
    colour: @getColour()
