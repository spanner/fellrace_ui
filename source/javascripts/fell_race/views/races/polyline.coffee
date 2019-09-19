class FellRace.Views.RacePolyline extends MapStick.Polyline
  defaultOptions:
    strokeWeight: 4
    strokeOpacity: 0.5
    editable: true
    clickable: false

  bindings:
    path:
      attribute: "encoded_route"
      modelChanged: ({encoded_route:string}={}) ->
        MapStick.decodePathString(string or= "")
      overlayChanged: (path, e) ->
        string = MapStick.encodePathString(path or=[])
        {encoded_route: string}
    strokeColor: "route_colour"
    visibility: "show_route"

  modelEvents:
    destroy: "remove"
    extend: "draw"

  initialize: ({map:map}={}) ->
    @checkpoints = new FellRace.Views.AdminCheckpointMarkers
      collection: @model.checkpoints
      map: map
    @checkpoints.show()

  hide: =>
    super
    @checkpoints.hide()

  show: =>
    super
    @checkpoints.show()

class FellRace.Views.RacePolylines extends MapStick.OverlayCollection
  itemView: FellRace.Views.RacePolyline
