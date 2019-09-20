FellRace = {}
FellRace.Models = {}
FellRace.Collections = {}
FellRace.Views = {}
FellRace.months =
  full: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
  short: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

root = exports ? this
root.FellRace = FellRace

class FellRace.Application extends Marionette.Application
  regions:
    gmapRegion: "#fell_race_map"
    contentRegion: "#fell_race_info"

  constructor: ->
    super
    Marionette.Renderer.render = @render
    root._fr = @
    @addRegions @regions
    @race_publications = new FellRace.Collections.RacePublications

    @mapView = new FellRace.Views.Map()
    @gmapRegion.show @mapView
    @mapView.publicView()

    races_count = race_slugs.length
    fetched_count = 0
    map_bounds = new google.maps.LatLngBounds
    _.each race_slugs, (slug) =>
      race = @race_publications.add slug: slug
      race.url = "//api.#{@domain()}/race_publications/#{slug}.json"
      race.fetch
        success: =>
          fetched_count += 1
          if bounds = race.getBounds()
            map_bounds.union bounds
            if fetched_count is races_count
              @mapView.getMap().fitBounds map_bounds
        
      race.set selected: true

    stylesheet_url = "//#{@domain()}/stylesheets/external.css"
    $('head').append('<link rel="stylesheet" type="text/css" href="' + stylesheet_url + '">')

    if info_element
      races_list = new FellRace.Views.ExternalRacePublicationsList
        collection: @race_publications
        parent: this
      @contentRegion.show races_list

  apiUrl: =>
    @_api_url

  domain: ->
    dc = new RegExp(/\.dev/)
    if dc.test(window.location.href)
      "fr.dev"
    else
      "fellrace.org.uk"

  moveMapTo: (model,zoom) =>
    @mapView.moveTo model, zoom

  render: (template, data) ->
    path = "templates/#{template}"
    if template?
      throw("Template '" + path + "' not found!") unless JST[path]
      JST[path](data)
    else
      ""

class FellRace.Views.ExternalRacePublication extends FellRace.View
  template: 'race_publications/external'
  className: "race"

  events:
    'click .opener': 'toggle'

  bindings:
    '.name': 'name'
    '.distance': 'distance'
    '.climb': "climb"
    '.cat': 'cat'
    '.route_elevation': "route_elevation"
    '.description':
      observe: 'description'
      updateMethod: "html"
    'span.race_profile':
      observe: 'route_profile'
      update: "peify"

  onRender: =>
    @stickit()
    new FellRace.Views.CheckpointsList(collection: @model.checkpoints, el: @$el.find("ul.checkpoints")).render()
    new FellRace.Views.RecordsList(collection: @model.records, el: @$el.find("ul.records")).render()
    new FellRace.Views.AttachmentsList(collection: @model.attachments, el: @$el.find("ul.attachments")).render()

  peify: ($el, value, model, options) =>
    checkExist = setInterval(() =>
      if $el.length
        clearInterval(checkExist)
        $el.text value
        $el.peity("line")
        @old_peify()
    , 100)

  old_peify: () =>
    w = @$el.width()
    @$el.find('span.race_profile').peity "line",
      fill: "#f2f0ed"
      stroke: "#f2f0ed"
      width: w
      height: w / 5
    

  hasAny: (array) =>
    array.length > 0

  toggle: =>
    @model.trigger "toggle_select"


class FellRace.Views.ExternalRacePublicationsList extends FellRace.CollectionView
  childView: FellRace.Views.ExternalRacePublication



# class FellRace.Views.ExternalMap extends FellRace.View
#   template: 'events/external_map'
#
#   mapConfig:
#     center: new google.maps.LatLng 54.4098399744, -2.9730033900
#     zoom: 10
#     mapTypeId: "Open"
#     scrollwheel: false
#     zoomControlOptions:
#       position: google.maps.ControlPosition.RIGHT_TOP
#     panControlOptions:
#       position: google.maps.ControlPosition.RIGHT_TOP
#     mapTypeControlOptions:
#       mapTypeIds: [
#         "Open",
#         "OS",
#         google.maps.MapTypeId.ROADMAP,
#         google.maps.MapTypeId.SATELLITE
#       ]
#       style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
#
#   onRender: () =>
#     throw new Error("Google maps API is not loaded.") unless google and google.maps
#     @$el.css
#       height: "100%"
#       width: "100%"
#     @$el.find(".map_holder").css
#       height: "100%"
#       width: "100%"
#     @_gmap = new google.maps.Map @$el.find(".map_holder")[0], @mapConfig
#     @addMapTypes()
#     polys = new FellRace.Views.RacePublicationPolylines
#       collection: @model.race_publications
#       map: @_gmap
#     polys.show()
#
#   setMapOptions: =>
#     @_gmap.setOptions _.extend(@mapConfig, @model.getMapOptions())
#
#   addMapTypes: =>
#     @_gmap.mapTypes.set "Open", new google.maps.ImageMapType
#       getTileUrl: (coord, zoom) ->
#         return "http://tile.opencyclemap.org/landscape/" + zoom + "/" + coord.x + "/" + coord.y + ".png"
#       tileSize: new google.maps.Size(256, 256)
#       name: "OSM"
#       maxZoom: 18
#
#     @_gmap.mapTypes.set "OS", new google.maps.ImageMapType
#       getTileUrl: (coord, zoom) =>
#         "http://ecn.t#{"0123".charAt(Math.floor(Math.random() * 3))}.tiles.virtualearth.net/tiles/r#{@tileXYToQuadKey(coord.x,coord.y,zoom)}?g=1567&lbl=l1&productSet=mmOS"
#       tileSize: new google.maps.Size(256, 256)
#       name: "OS"
#       maxZoom: 17
#       minZoom: 10
#
#     shadow = new google.maps.ImageMapType
#       getTileUrl: (coord, zoom) ->
#         "http://toolserver.org/~cmarqu/hill/#{zoom}/#{coord.x}/#{coord.y}.png"
#       tileSize: new google.maps.Size(256, 256)
#       name: "OS"
#       maxZoom: 17
#       minZoom: 10
#
#     unless document.all? && document.documentMode? && document.documentMode < 9
#       @_gmap.overlayMapTypes.insertAt(0, shadow)
#       google.maps.event.addListener @_gmap, 'maptypeid_changed', =>
#         type = @_gmap.getMapTypeId()
#         if type=="OS" || type=="roadmap"
#           shadow.setOpacity(0.7)
#         else
#           shadow.setOpacity(0)
#
#       google.maps.event.trigger @_gmap, "maptypeid_changed"
#
#   tileXYToQuadKey: (tileX, tileY, levelOfDetail) ->
#     quadKey = ""
#     for i in [levelOfDetail..1]
#       digit = '0'
#       mask = 1 << (i - 1)
#       if (tileX & mask) != 0
#         digit++
#       if (tileY & mask) != 0
#         digit++
#         digit++
#       quadKey = "#{quadKey}#{digit}"
#     quadKey



