class FellRace.Views.RacePolyline extends MapStick.Polyline
  defaultOptions:
    strokeWeight: 4
    strokeOpacity: 0.5

  bindings:
    path:
      attribute: "route"
      modelChanged: ({route:string}={}) ->
        MapStick.decodePathString(string or= "")
      overlayChanged: (path, e) ->
        string = MapStick.encodePathString(path or=[])
        {encoded_route: string}
    strokeColor: "route_colour"
    visibility: "show_route"
    editable: "selected"
    clickable:
      attribute: "selected"
      modelChanged: "clickable"

  overlayEvents:
    "click": "select"

  modelEvents:
    destroy: "remove"
    extend: "draw"

  initialize: ({map:map}={}) ->
    @checkpoints = new FellRace.Views.CheckpointMarkers
      collection: @model.checkpoints
      map: map

  clickable: ({selected:selected}={}) =>
    !selected

  select: =>
    @model.trigger "select"

  hide: =>
    super
    @checkpoints.hide()

  show: =>
    super
    @checkpoints.show()

class FellRace.Views.RacePolylines extends MapStick.OverlayCollection
  itemView: FellRace.Views.RacePolyline
