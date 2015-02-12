#= require jquery
#= require modernizr
#= require jquery.peity
#= require hamlcoffee
#= require underscore
#= require underscore.string
#= require backbone
#= require backbone.marionette
#= require backbone.stickit
#= require backbone.mapstick
#= require lib/extensions
#= require lib/utilities
#= require lib/map_utilities
#= require lib/sortable
#= require latlon
#= require osgridref
#= require moment
#= require coordtransform

#= require_tree ../templates
#= require external
#= require_tree ./fell_race/models
#= require_tree ./fell_race/collections
#= require_tree ./fell_race/views/race_publications
#= require_tree ./fell_race/views/instances/published
#= require_tree ./fell_race/views/checkpoints/published
#= require_tree ./fell_race/views/attachments/published
#= require_tree ./fell_race/views/links/published
#= require_tree ./fell_race/views/records/published
#= require_tree ./fell_race/views/checkpoints/published

Backbone.Marionette.Renderer.render = (template, data) ->
  if template?
    throw("Template '" + template + "' not found!") unless JST[template]
    JST[template](data)
  else
    ""

window.FellRace = new Backbone.Marionette.Application()
FellRace.months =
  full: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
  short: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
FellRace.Models = {}
FellRace.Collections = {}
FellRace.Views = {}

FellRace.start = ->
  publication = new FellRace.Models.Publication slug: event_slug
  publication.url = "//#{FellRace.domain()}#{publication.urlRoot}/#{event_slug}.json"
  stylesheet_url = "//#{FellRace.domain()}/assets/external.css"
  $('head').append('<link rel="stylesheet" type="text/css" href="' + stylesheet_url + '">');

  publication.fetch
    success: (a, b, c) ->
      FellRace.mapView?.setMapOptions()      
    error: ->
      console.log('error', "Error during initialisation.")

  if info_element
    FellRace.infoView = new FellRace.Views.ExternalPublication(model: publication, el: $(info_element))
    FellRace.infoView.render()

  if map_element
    FellRace.mapView = new FellRace.Views.ExternalMap(model: publication, el: $(map_element))
    FellRace.mapView.render()
    
  $.pub = publication


FellRace.domain = ->
  dc = new RegExp(/\.dev/)
  if dc.test(window.location.href)
    "fr.dev"
  else
    "fellrace.org.uk"






class FellRace.Views.ExternalPublication extends Backbone.Marionette.ItemView
  template: 'publications/external'
  className: "event"

  bindings:
    '#name': 'name'
    '#description': "clean_description"

  onRender: =>
    @stickit()
    new FellRace.Views.ExternalRacePublicationsList(
      collection: @model.race_publications
      parent: this
      el: @$el.find(".races")
    ).render()

    
class FellRace.Views.ExternalRacePublication extends Backbone.Marionette.ItemView
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
    '.description': 'clean_description'
    'span.race_profile':
      observe: 'route_profile'
      update: "peify"

  onRender: =>
    @stickit()
    new FellRace.Views.PublishedCheckpointsList(collection: @model.checkpoints, el: @$el.find("ul.checkpoints")).render()
    new FellRace.Views.PublishedRecordsList(collection: @model.records, el: @$el.find("ul.records")).render()
    new FellRace.Views.PublishedAttachmentsList(collection: @model.attachments, el: @$el.find("ul.attachments")).render()

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


class FellRace.Views.ExternalRacePublicationsList extends Backbone.Marionette.CollectionView
  itemView: FellRace.Views.ExternalRacePublication



class FellRace.Views.ExternalMap extends Backbone.Marionette.ItemView
  template: 'events/external_map'

  mapConfig:
    center: new google.maps.LatLng 54.4098399744, -2.9730033900
    zoom: 10
    mapTypeId: "Open"
    scrollwheel: false
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

  onRender: () =>
    throw new Error("Google maps API is not loaded.") unless google and google.maps
    @$el.css
      height: "100%"
      width: "100%"
    @$el.find(".map_holder").css
      height: "100%"
      width: "100%"
    @_gmap = new google.maps.Map @$el.find(".map_holder")[0], @mapConfig
    @addMapTypes()
    polys = new FellRace.Views.RacePublicationPolylines
      collection: @model.race_publications
      map: @_gmap
    polys.show()

  setMapOptions: =>
    @_gmap.setOptions _.extend(@mapConfig, @model.getMapOptions())

  addMapTypes: =>
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

    unless document.all? && document.documentMode? && document.documentMode < 9
      @_gmap.overlayMapTypes.insertAt(0, shadow)
      google.maps.event.addListener @_gmap, 'maptypeid_changed', =>
        type = @_gmap.getMapTypeId()
        if type=="OS" || type=="roadmap"
          shadow.setOpacity(0.7)
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




$ ->
  FellRace.start()
