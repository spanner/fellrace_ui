class Home.Views.Map extends Backbone.Marionette.ItemView
  initialize: =>
    lat = 54.43063302098403
    lng = -3.022871704101595
    $.zoom = zoom = 11
    style = "OS"
    $.center = center = new google.maps.LatLng lat, lng
    map_state =
      center: center
      scrollwheel: false
      zoom: parseInt(zoom)
      mapTypeId: style
      zoomControlOptions:
        position: google.maps.ControlPosition.RIGHT_TOP
      panControlOptions:
        position: google.maps.ControlPosition.RIGHT_TOP
      mapTypeControlOptions:
        mapTypeIds: [
          "Open",
          "OS",
          google.maps.MapTypeId.ROADMAP,
          google.maps.MapTypeId.SATELLITE
        ]
        style: google.maps.MapTypeControlStyle.DROPDOWN_MENU

    FellRace.gmap = @_gmap = new google.maps.Map $('.map_holder')[0], map_state

    @_gmap.addMapTypes()

  getMap: () =>
    @_gmap

  addMapTypes: () =>
    @_gmap.mapTypes.set "Open", new google.maps.ImageMapType
      getTileUrl: (coord, zoom) ->
        return "http://tile.opencyclemap.org/landscape/" + zoom + "/" + coord.x + "/" + coord.y + ".png"
      tileSize: new google.maps.Size(256, 256)
      name: "OSM"
      maxZoom: 18

    @_gmap.mapTypes.set "OS", new google.maps.ImageMapType
      getTileUrl: (coord, zoom) ->
        "http://ecn.t#{"0123".charAt(Math.floor(Math.random() * 3))}.tiles.virtualearth.net/tiles/r#{$.tileXYToQuadKey(coord.x,coord.y,zoom)}?g=1567&lbl=l1&productSet=mmOS"
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

    unless document.all? && document.documentMode? && document.documentMode < 9
      @_gmap.overlayMapTypes.insertAt(0, shadow)
      google.maps.event.addListener @_gmap, 'maptypeid_changed', =>
        type = @_gmap.getMapTypeId()
        if type=="OS" || type=="roadmap"
          shadow.setOpacity(0.7)
        else
          shadow.setOpacity(0)

      google.maps.event.trigger @_gmap, "maptypeid_changed"

  updateModel: () =>
    center = @_gmap.getCenter()
    data =
      map_lat: center.lat()
      map_lng: center.lng()
      map_zoom: @_gmap.getZoom()
      map_style: @_gmap.getMapTypeId()
    @model.save data,
      success: =>
        $.notify "success", "Map set as '#{data.map_style}' at the current position"

    # map.mapTypes.set "Open", new google.maps.ImageMapType
    #   getTileUrl: (coord, zoom) ->
    #     "http://tile.opencyclemap.org/cycle/" + zoom + "/" + coord.x + "/" + coord.y + ".png"
    #   tileSize: new google.maps.Size(256, 256)
    #   name: "OSM"
    #   maxZoom: 18
    # 
    # map.mapTypes.set "OS", new google.maps.ImageMapType
    #   getTileUrl: (coord, zoom) ->
    #     if zoom < 10
    #       "http://a.tile.openstreetmap.org/#{zoom}/#{coord.x}/#{coord.y}.png"
    #     else
    #       "http://ecn.t#{"0123".charAt(Math.floor(Math.random()*3))}.tiles.virtualearth.net/tiles/r#{$.tileXYToQuadKey(coord.x,coord.y,zoom)}?g=1567&lbl=l1&productSet=mmOS"
    #   tileSize: new google.maps.Size(256, 256)
    #   name: "OS"
    #   maxZoom: 17
    #   # minZoom: 10
    # 
    # shadow = new google.maps.ImageMapType
    #   getTileUrl: (coord, zoom) ->
    #     "http://toolserver.org/~cmarqu/hill/#{zoom}/#{coord.x}/#{coord.y}.png"
    #   tileSize: new google.maps.Size(256, 256)
    #   name: "OS"
    #   maxZoom: 17
    #   minZoom: 10
    # 
    # 
    # unless document.all? && document.documentMode? && document.documentMode < 9
    #   map.overlayMapTypes.insertAt(0, shadow)
    #   google.maps.event.addListener map, 'maptypeid_changed', =>
    #     type = map.getMapTypeId()
    #     if type=="OS" || type=="roadmap"
    #       shadow.setOpacity(0.7)
    #     else
    #       shadow.setOpacity(0)
    # 
    #   google.maps.event.trigger map, "maptypeid_changed"
