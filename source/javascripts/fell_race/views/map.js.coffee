class FellRace.Views.Map extends Backbone.Marionette.ItemView
  template: 'map'
  className: 'gmap'
  mapConfig: =>
    center: new google.maps.LatLng @startLat(), @startLng()
    zoom: @startZoom()
    mapTypeId: "Open"
    # scrollwheel: false
    zoomControlOptions:
      position: google.maps.ControlPosition.RIGHT_TOP
    panControlOptions:
      position: google.maps.ControlPosition.RIGHT_TOP
    mapTypeControlOptions:
      position: google.maps.ControlPosition.TOP_RIGHT
      mapTypeIds: [
        "Open",
        "OS",
        "OOM",
        google.maps.MapTypeId.ROADMAP,
        google.maps.MapTypeId.SATELLITE
      ]
      style: google.maps.MapTypeControlStyle.DROPDOWN_MENU

  _race: null

  startLat: ->
    parseFloat(localStorage["fr_lat"]) or 54.4098399744

  startLng: ->
    parseFloat(localStorage["fr_lng"]) or -2.9730033900

  startZoom: ->
    parseInt(localStorage["fr_zoom"],10) or 11

  onRender: () =>
    throw new Error("Google maps API is not loaded.") unless google and google.maps
    @_gmap = new google.maps.Map @$el.find('.map_holder')[0], @mapConfig()
    google.maps.event.addListener @_gmap, "dragend", @setState
    @addMapTypes()
    @userMarker = new FellRace.Views.UserMarker?(
      model: _fellrace.currentUser?()
      map: @_gmap
    )

    @_polys = new FellRace.Views.RacePublicationPolylines
      collection: _fellrace.race_publications
      map: @_gmap

  showRace: (race) =>
    @removeRace()
    @_race_poly = new FellRace.Views.RacePolyline
      model: race
      map: @_gmap
    @moveTo race

  removeRace: =>
    @_race_poly?.hide()
    @_race_poly = null

  indexView: =>
    _fellrace.race_publications.deselectAll()

  publicView: =>
    @removeRace()
    @_polys.show()

  adminView: =>
    @_polys.hide()

  setOptions: (opts={}) =>
    @_gmap.setOptions _.extend(_.clone(@mapConfig), opts)

  getMap: =>
    @_gmap

  moveTo: (model,zoom=16) =>
    if model.isPoint
      @_gmap.panTo model.getLatLng()
      @_gmap.setZoom zoom
    else
      if bounds = model.getBounds()
        if bounds.isEmpty()
          @setOptions model.getMapOptions()
        else
          @_gmap.fitBounds bounds
    @_gmap.panBy _fellrace.offsetX(), 0

  setState: =>
    localStorage["fr_lat"] = @_gmap.center.lat()
    localStorage["fr_lng"] = @_gmap.center.lng()
    localStorage["fr_zoom"] = @_gmap.zoom

  addMapTypes: =>
    
    # @_gmap.mapTypes.set "OOM", new google.maps.ImageMapType
    #   getTileUrl: (coord, zoom) ->
    #     return "https://tiler#{"123".charAt(Math.floor(Math.random() * 2))}.oobrien.com/oterrain/#{zoom}/#{coord.x}/#{coord.y}.png"
    #   tileSize: new google.maps.Size(256, 256)
    #   name: "OOM"
    #   maxZoom: 17
    #   minZoom: 12
    #
    @_gmap.mapTypes.set "Open", new google.maps.ImageMapType
      getTileUrl: (coord, zoom) ->
        return "https://#{"abc".charAt(Math.floor(Math.random() * 2))}.tile.thunderforest.com/landscape/#{zoom}/#{coord.x}/#{coord.y}.png?apikey=f42f7cc1c70d465588f47c2a78648ad7"
      tileSize: new google.maps.Size(256, 256)
      name: "OSM"
      maxZoom: 18

    @_gmap.mapTypes.set "OS", new google.maps.ImageMapType
      getTileUrl: (coord, zoom) =>
        "https://t#{"0123".charAt(Math.floor(Math.random() * 3))}.ssl.ak.tiles.virtualearth.net/tiles/r#{@tileXYToQuadKey(coord.x,coord.y,zoom)}.png?g=3467&productSet=mmOS"
      tileSize: new google.maps.Size(256, 256)
      name: "OS"
      maxZoom: 17
      minZoom: 10

    shadow = new google.maps.ImageMapType
      getTileUrl: (coord, zoom) ->
        "https://#{"abc".charAt(Math.floor(Math.random() * 2))}.tiles.wmflabs.org/hillshading/#{zoom}/#{coord.x}/#{coord.y}.png"
        # "https://toolserver.org/~cmarqu/hill/#{zoom}/#{coord.x}/#{coord.y}.png"
      tileSize: new google.maps.Size(256, 256)
      name: "OS"
      maxZoom: 17
      minZoom: 10

    # unless document.all? && document.documentMode? && document.documentMode < 9
    #   @_gmap.overlayMapTypes.insertAt(0, shadow)
    #   google.maps.event.addListener @_gmap, 'maptypeid_changed', =>
    #     type = @_gmap.getMapTypeId()
    #     if type is "OS" or type is "roadmap" or type is "OOM"
    #       shadow.setOpacity(0.8)
    #     else
    #       shadow.setOpacity(0)
    #
    #   google.maps.event.trigger @_gmap, "maptypeid_changed"

  tileXYToQuadKey: (tileX, tileY, levelOfDetail) ->
    quadKey = ""
    for i in [levelOfDetail..1]
      digit = '0'
      mask = 1 << (i - 1)
      if (tileX & mask) != 0
        digit++
      if (tileY & mask) != 0
        digit++
        digit++
      quadKey = "#{quadKey}#{digit}"
    quadKey

