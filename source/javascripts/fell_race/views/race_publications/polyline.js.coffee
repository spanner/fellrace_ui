class FellRace.Views.RacePublicationPolyline extends MapStick.Polyline
  defaultOptions:
    strokeWeight: 4
    strokeOpacity: 0.4
    strokeColor: "#d1005d"
    zIndex: 1

  bindings:
    path:
      attributes: ["route","checkpoint_route"]
      modelChanged: "path"
    icons:
      attributes: ["colour","selected"]
      modelChanged: "icons"
    strokeOpacity:
      attribute: "selected"
      modelChanged: "strokeOpacity"
    visible:
      attributes: ["route","selected"]
      modelChanged: "visible"
    clickable:
      attribute: "selected"
      modelChanged: "unclickable"

  overlayEvents:
    click: "select"

  initialize: ({map:map}={}) ->
    @checkpoints = new FellRace.Views.CheckpointMarkers
      collection: @model.checkpoints
      map: map

  select: =>
    _fellrace.navigate("/races/#{@model.get("slug")}") unless @model.get("selected")

  path: ({route:route_string,checkpoint_route:cp_route_string}={}) ->
    MapStick.decodePathString(route_string or cp_route_string or "")    

  icons: ({colour:colour,selected:selected}={}) =>
    if selected
      [
        icon:
          path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW
          fillOpacity: 0.8
          scale: 5
          strokeWeight: 1
          strokeColor: colour
          strokeOpacity: 0.8
        offset: "80px"
        repeat: "180px"
        icon:
          path: 'M 0,-1 0,1'
          strokeColor: colour
          strokeOpacity: 0.8
          strokeWeight: 5
          scale: 5
        offset: "0"
        repeat: "20px"
      ]

  visible: ({route:route,selected:selected}={}) =>
    !(!route and selected)

  strokeOpacity: ({selected:selected}={}) =>
    if selected then 0 else @defaultOptions.strokeOpacity

  hide: =>
    super
    @checkpoints.hide()

  show: =>
    super
    @checkpoints.show()

  unclickable: ({selected:selected}={}) =>
    !selected

class FellRace.Views.RacePublicationPolylines extends MapStick.OverlayCollection
  itemView: FellRace.Views.RacePublicationPolyline
