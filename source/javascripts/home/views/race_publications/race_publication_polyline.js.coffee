class Home.Views.RacePublicationPolyline extends Backbone.Marionette.ItemView
  modelEvents:
    deselect: "unhighlight"
    goTo: "goTo"
  polylineEvents:
    click: "click"
  polylineType: google.maps.Polyline
  polylineOptions:
    strokeWeight: 5
    strokeOpacity: 0.45
    strokeColor: "#d1005d"
    zIndex: 1
  selectedPolylineOptions:
    zIndex: 99
    strokeOpacity: 1
    strokeColor: "#FF3DF2"

  initialize: () ->
    # create polyline and listen
    @polyline = new google.maps.Polyline
    path = @model.getPath()
    @polyline.setPath path
    @polyline.setMap Home.gmap
    @polyline.setOptions @polylineOptions
    @bounds = new google.maps.LatLngBounds

    for point in path
      @bounds.extend point

    for evt, handler of @polylineEvents
      @listenToMVCEvent(@polyline, evt, this[handler])

  listenToMVCEvent: (object, event, handler) =>
    google.maps.event.addListener(object, event, handler)

  unhighlight: =>
    @polyline.setOptions @polylineOptions

  highlight: =>
    @polyline.setOptions @selectedPolylineOptions

  goTo: =>
    @highlight()
    Home.gmap.fitBounds @bounds

  click: =>
    Home.selected_race?.trigger "deselect"
    @model.trigger "goTo"
