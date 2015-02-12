class FellRace.Views.Map extends Backbone.Marionette.ItemView
  template: 'events/map'
  className: 'gmap'
  mapConfig:
    center: new google.maps.LatLng 54.4098399744, -2.9730033900
    zoom: 10
    mapTypeId: "OS"
    # scrollwheel: false
    zoomControlOptions:
      position: google.maps.ControlPosition.RIGHT_TOP
    panControlOptions:
      position: google.maps.ControlPosition.RIGHT_TOP
    mapTypeControlOptions:
      mapTypeIds: [
        "Open",
        "OS",
        # "OOM",
        google.maps.MapTypeId.ROADMAP,
        google.maps.MapTypeId.SATELLITE
      ]
      style: google.maps.MapTypeControlStyle.DROPDOWN_MENU

  publication_bundles: {}
  preview_bundles: {}
  event_bundles: {}

  initialize: ->
    # _fellrace.publications.on "add", (model) =>
    #   @constructPublicationBundle model
    # _fellrace.previews.on "add", (model) =>
    #   @constructPreviewBundle model
    # _fellrace.events.on "add", (model) =>
    #   @constructEventBundle model

  onRender: () =>
    throw new Error("Google maps API is not loaded.") unless google and google.maps
    @_gmap = new google.maps.Map @$el.find('.map_holder')[0], @mapConfig
    @addMapTypes()
    @userMarker = new FellRace.Views.UserMarker
      model: _fellrace.currentUser()
      map: @_gmap

  setOptions: (opts={}) =>
    @_gmap.setOptions _.extend(_.clone(@mapConfig), opts)
    @_gmap.panBy _fellrace.offsetX(), _fellrace.offsetY()

  getMap: =>
    @_gmap

  removeBundle: (model, bundles) =>
    bundles[model.cid].hide()
    delete bundles[model.cid]

  constructPublicationBundle: (model) =>
    bundle = @publication_bundles[model.cid] =
      races: new FellRace.Views.RacePublicationPolylines
        collection: model.race_publications
        map: @_gmap
      simple_races: new FellRace.Views.SimpleRacePublicationPolylines
        collection: model.race_publications
        map: @_gmap
      hide: =>
        bundle.races.hide()
        bundle.simple_races.hide()
      showSimple: =>
        bundle.races.hide()
        bundle.simple_races.show()
      show: =>
        @hideEvents()
        @showSimplePublications()
        bundle.races.show()
        bundle.simple_races.hide()

    model.on "select", =>
      bundle.show()

    bundle.showSimple()
    bundle

  constructPreviewBundle: (model) =>
    bundle = @preview_bundles[model.cid] =
      races: new FellRace.Views.RacePublicationPolylines
        collection: model.race_publications
        map: @_gmap
      show: =>
        @hidePublications()
        @hideEvents()
        bundle.races.show()
      hide: =>
        bundle.races.hide()

    model.on "select", =>
      bundle.show()

    bundle

  constructEventBundle: (model) =>
    bundle = @event_bundles[model.cid] =
      races: new FellRace.Views.RacePolylines
        collection: model.races
        map: @_gmap
      hide: =>
        bundle.races.hide()
      show: =>
        @hidePublications()
        @hideEvents()
        bundle.races.show()

    model.on "select", =>
      bundle.show()
    bundle.hide()
    bundle

  goToModel: (model) =>
    unless @model is model
      @setOptions model.getMapOptions()
      # @setOptions _.omit model.getMapOptions(), "mapTypeId"
      @model = model
    model.trigger "select", model

  index: =>
    @model = null
    @hideEvents()
    @showSimplePublications()

  hideEvents: =>
    @hideBundles @event_bundles

  hidePublications: =>
    @hideBundles @publication_bundles
    @hideBundles @preview_bundles

  showSimplePublications: =>
    @hideBundles @preview_bundles
    _.each @publication_bundles, (bundle) =>
      bundle.showSimple()

  hideBundles: (bundles) =>
    _.each bundles, (bundle) =>
      bundle.hide()

  showBundles: (bundles) =>
    _.each bundles, (bundle) =>
      bundle.show()

  addMapTypes: =>
    
    # @_gmap.mapTypes.set "OOM", new google.maps.ImageMapType
    #   getTileUrl: (coord, zoom) ->
    #     return "http://tiler#{"123".charAt(Math.floor(Math.random() * 2))}.oobrien.com/oterrain/" + zoom + "/" + coord.x + "/" + coord.y + ".png"
    #   tileSize: new google.maps.Size(256, 256)
    #   name: "OOM"
    #   maxZoom: 17
    #   minZoom: 12
    
    @_gmap.mapTypes.set "Open", new google.maps.ImageMapType
      getTileUrl: (coord, zoom) ->
        return "http://tile.opencyclemap.org/landscape/" + zoom + "/" + coord.x + "/" + coord.y + ".png"
      tileSize: new google.maps.Size(256, 256)
      name: "OSM"
      maxZoom: 18

    @_gmap.mapTypes.set "OS", new google.maps.ImageMapType
      getTileUrl: (coord, zoom) =>
        "http://ecn.t#{"0123".charAt(Math.floor(Math.random() * 3))}.tiles.virtualearth.net/tiles/r#{@tileXYToQuadKey(coord.x,coord.y,zoom)}?g=1567&lbl=l1&productSet=mmOS"
      tileSize: new google.maps.Size(256, 256)
      name: "OS"
      maxZoom: 17
      minZoom: 10

    shadow = new google.maps.ImageMapType
      getTileUrl: (coord, zoom) ->
        "http://toolserver.org/~cmarqu/hill/#{zoom}/#{coord.x}/#{coord.y}.png"
      tileSize: new google.maps.Size(256, 256)
      name: "OS"
      maxZoom: 17
      minZoom: 10

    # unless document.all? && document.documentMode? && document.documentMode < 9
    #   @_gmap.overlayMapTypes.insertAt(0, shadow)
    #   google.maps.event.addListener @_gmap, 'maptypeid_changed', =>
    #     type = @_gmap.getMapTypeId()
    #     if type=="OS" || type=="roadmap"
    #       shadow.setOpacity(0.7)
    #     else
    #       shadow.setOpacity(0)

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

