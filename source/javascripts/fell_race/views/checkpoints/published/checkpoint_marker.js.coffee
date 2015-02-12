class FellRace.Views.PublishedCheckpointMarker extends MapStick.Marker
  defaultOptions:
    labelInBackground: true
    labelClass: "label"
    labelAnchor: new google.maps.Point(-17, 10)

  # buildOverlay: (options) =>
  #   new MarkerWithLabel(options)

  overlayEvents:
    click: "select"

  modelEvents:
    go_to: "goTo"

  bindings:
    position:
      lat: "lat"
      lng: "lng"
    opacity:
      attribute: "race_selected"
      modelChanged: "strength"
    labelStyle:
      attributes: ["colour","race_selected"]
      modelChanged: "labelStyle"
    labelVisible:
      attribute: "fixed"
      modelChanged: "labelVisible"
    labelContent:
      attributes: ["pos","name"]
      modelChanged: "labelContent"
    icon:
      attributes: ["name","colour"]
      modelChanged: "icon"
    visible:
      attribute: "duplicate"
      modelChanged: "visible"

  textColour: (colour) =>
    c = colour.substring(1) # strip #
    rgb = parseInt(c, 16)   # convert rrggbb to decimal
    r = (rgb >> 16) & 0xff  # extract red
    g = (rgb >>  8) & 0xff  # extract green
    b = (rgb >>  0) & 0xff  # extract blue
    if (0.2126 * r + 0.7152 * g + 0.0722 * b) < 150
      "white"
    else
      "black"

  select: =>
    @model.trigger "select"

  labelStyle: ({colour:colour,race_selected:race_selected}={}) =>
    "background-color": colour
    color: @textColour colour
    opacity: @strength(race_selected:race_selected)

  labelVisible: ({fixed:fixed}={}) =>
    !fixed

  labelContent: ({pos:pos,name:name}={}) =>
    text = ""
    previous_cps = @model.collection.models.filter (cp) =>
      @distanceTo(cp) < (20 / 1000) and name is cp.get("name") and pos > cp.get("pos")
    for cp in previous_cps
      cp.set duplicate: true
      text = "#{text}#{cp.get "pos"},"
    "#{text}#{pos}"

  icon: ({colour:colour,name:name}={}) =>
    icon_path = switch name
      when "Start" then "M -20 15 L 0 -20 L 20 15 L -20 15"
      when "Finish" then "M -18 0 a18 18 0 0 0 36 0 a18 18 0 0 0 -36 0 M -12 0 a12 12 0 0 0 24 0 a12 12 0 0 0 -24 0"
      when "Start and Finish" then "M -18 0 a18 18 0 0 0 36 0 a18 18 0 0 0 -36 0 M -20 12 L 0 -23 L 20 12 L -20 12"
      else "M -18 0 a18 18 0 0 0 36 0 a18 18 0 0 0 -36 0"
    {
      scale: 1
      path: icon_path
      strokeColor: colour
      strokeWeight: 3
    }

  strength: ({race_selected:race_selected}={}) =>
    if race_selected then 0.8 else 0.3

  distanceTo: (cp) =>
    @model.getLatLng().kmTo cp.getLatLng()

  visible: ({duplicate:duplicate}={}) =>
    !duplicate

  hide: =>
    super

  show: =>
    super

  goTo: =>
    @select()
    _fellrace.mapView?.setOptions
      center: @model.getLatLng()
      zoom: @model.getPubZoom() + 1 || 16

class FellRace.Views.PublishedCheckpointMarkers extends MapStick.CollectionView
  itemView: FellRace.Views.PublishedCheckpointMarker
