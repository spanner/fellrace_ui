class FellRace.Views.CheckpointMarker extends MapStick.Marker
  defaultOptions:
    labelInBackground: true
    labelClass: "label"
    labelAnchor: new google.maps.Point(-17, 10)
    raiseOnDrag: false

  # buildOverlay: (options) =>
  #   new MarkerWithLabel(options)

  bindings:
    labelVisible:
      attribute: "name"
      modelChanged: "labelVisible"
    labelContent: "pos"
    labelStyle:
      attributes: ["colour","race_selected"]
      modelChanged: "labelStyle"
    opacity:
      attribute: "race_selected"
      modelChanged: "strength"
    icon:
      attributes: ["name","colour"]
      modelChanged: "icon"
    position:
      lat: "lat"
      lng: "lng"
    draggable: "race_selected"

  overlayEvents:
    click: "select"

  labelStyle: ({colour:colour,race_selected:race_selected}={}) =>
    "background-color": colour
    color: @textColour colour
    opacity: @strength race_selected:race_selected

  labelVisible: ({name:name}={}) =>
    name isnt "Start" and name isnt "Finish"

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

  textColour: (colour) =>
    if colour
      c = colour.substring(1)      # strip #
      rgb = parseInt(c, 16)   # convert rrggbb to decimal
      r = (rgb >> 16) & 0xff  # extract red
      g = (rgb >>  8) & 0xff  # extract green
      b = (rgb >>  0) & 0xff  # extract blue
      if (0.2126 * r + 0.7152 * g + 0.0722 * b) < 150
        "white"
      else
        "black"
    else
      "black"

  strength: ({race_selected:race_selected}={}) =>
    if race_selected then 0.8 else 0.3

  select: =>
    @model.trigger "select"

class FellRace.Views.CheckpointMarkers extends MapStick.OverlayCollection
  itemView: FellRace.Views.CheckpointMarker
