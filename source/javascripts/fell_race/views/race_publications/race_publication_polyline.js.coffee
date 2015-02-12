class FellRace.Views.RacePublicationPolyline extends MapStick.Polyline
  defaultOptions:
    strokeOpacity: 0

  bindings:
    path:
      attribute: "route"
      modelChanged: "path"
    strokeColor: "colour"
    icons:
      attributes: ["colour","selected"]
      modelChanged: "icons"

  overlayEvents:
    click: "select"

  initialize: ({map:map}={}) ->
    @checkpoints = new FellRace.Views.PublishedCheckpointMarkers
      collection: @model.checkpoints
      map: map

  select: =>
    @model.trigger "select"

  path: ({route:string}={}) ->
    MapStick.decodePathString(string or= "")    

  icons: ({colour:colour,selected:selected}={}) =>
    strength = if selected then 0.8 else 0.35
    [
      {
        icon:
          path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW
          fillOpacity: strength
          scale: 5
          strokeWeight: 1
          strokeColor: colour
          strokeOpacity: strength
        offset: "80px"
        repeat: "180px"
      }
      {
        icon:
          path: 'M 0,-1 0,1'
          strokeColor: colour
          strokeOpacity: strength
          strokeWeight: 5
          scale: 5
        offset: "0"
        repeat: "20px"
      }
    ]

  hide: =>
    super
    @checkpoints.hide()

  show: =>
    super
    @checkpoints.show()

class FellRace.Views.RacePublicationPolylines extends MapStick.CollectionView
  itemView: FellRace.Views.RacePublicationPolyline



class FellRace.Views.SimpleRacePublicationPolyline extends MapStick.Polyline
  defaultOptions:
    strokeWeight: 5
    strokeOpacity: 0.3
    strokeColor: "#d1005d"
    zIndex: 1
  bindings:
    path:
      attributes: ["route","checkpoint_route"]
      modelChanged: "path"

  overlayEvents:
    click: "selectPublication"

  path: ({route:route,checkpoint_route:checkpoint_route}={}) =>
    route ?= checkpoint_route
    MapStick.decodePathString route    

  selectPublication: =>
    @model.trigger "select_publication"
    @model.trigger "select"

class FellRace.Views.SimpleRacePublicationPolylines extends MapStick.CollectionView
  itemView: FellRace.Views.SimpleRacePublicationPolyline
