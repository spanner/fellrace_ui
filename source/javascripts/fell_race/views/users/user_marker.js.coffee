class FellRace.Views.UserMarker extends MapStick.Marker
  defaultOptions:
    clickable: false
    draggable: false
    icon:
      scale: 8
      path: google.maps.SymbolPath.CIRCLE
      strokeColor: "blue"
      fillColor: "blue"
      fillOpacity: 0.6
      strokeWeight: 0

  bindings:
    position:
      lat: "lat"
      lng: "lng"

  initialize: ->
    @model.watchLocation()
