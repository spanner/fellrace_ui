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
    @initBingTiles().done =>
      @_gmap = new google.maps.Map @$el.find('.map_holder')[0], @mapConfig()
      google.maps.event.addListener @_gmap, "dragend", @setState
      @addMapTypes()
      @userMarker = new FellRace.Views.UserMarker
        model: _fr.currentUser?()
        map: @_gmap
      @_polys = new FellRace.Views.RacePublicationPolylines
        collection: _fr.race_publications
        map: @_gmap

  initBingTiles: =>
    apikey = _fr.config('bing_api_key')
    inited = $.Deferred()
    getter = $.getJSON("https://dev.virtualearth.net/REST/V1/Imagery/Metadata/Road?output=json&include=ImageryProviders&key=#{apikey}").done (response) =>
      if res = response.resourceSets[0].resources[0]
        @_bing =
          url: res.imageUrl
          subdomains: res.imageUrlSubdomains
          w: res.imageWidth
          h: res.imageHeight
      inited.resolve()
    inited.promise()

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
    _fr.race_publications.deselectAll()

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
    @_gmap.panBy _fr.offsetX(), 0

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
        apikey = _fr.config('osm_api_key')
        "https://tile.thunderforest.com/outdoors/#{zoom}/#{coord.x}/#{coord.y}.png?apikey=#{apikey}"
      tileSize: new google.maps.Size(256, 256)
      name: "OSM"
      maxZoom: 18

    bu = @_bing.url
    bs = @_bing.subdomains
    
    @_gmap.mapTypes.set "OS", new google.maps.ImageMapType
      getTileUrl: (coord, zoom) =>
        apikey = _fr.config('bing_api_key')
        url = bu.replace('{subdomain}', bs[Math.floor(Math.random() * bs.length)])
                .replace('{quadkey}', @tileXYToQuadKey(coord.x,coord.y,zoom))
                .replace('{culture}', "en-GB")
        "#{url}&productSet=mmOS&key=#{apikey}&c4w=1"
      tileSize: new google.maps.Size(@_bing.w, @_bing.h)
      name: "OS"
      maxZoom: 17
      minZoom: 10

    shadow = new google.maps.ImageMapType
      getTileUrl: (coord, zoom) ->
        "http://#{"abc".charAt(Math.floor(Math.random() * 2))}.tiles.wmflabs.org/hillshading/#{zoom}/#{coord.x}/#{coord.y}.png"
      tileSize: new google.maps.Size(256, 256)
      name: "OS"
      maxZoom: 17
      minZoom: 10

    unless document.all? && document.documentMode? && document.documentMode < 9
      @_gmap.overlayMapTypes.insertAt(0, shadow)
      google.maps.event.addListener @_gmap, 'maptypeid_changed', =>
        type = @_gmap.getMapTypeId()
        if type is "OS" or type is "roadmap" or type is "OSM"
          shadow.setOpacity(0.8)
        else
          shadow.setOpacity(0)

      google.maps.event.trigger @_gmap, "maptypeid_changed"

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

