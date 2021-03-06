class FellRace.Views.CheckpointMarker extends MapStick.Marker
  defaultOptions:
    labelInBackground: true
    labelClass: "label"
    labelAnchor: new google.maps.Point(-17, 10)
    opacity: 0.8
    clickable: false

  # buildOverlay: (options) =>
  #   new MarkerWithLabel(options)

  bindings:
    labelVisible:
      attribute: "name"
      modelChanged: "labelVisible"
    labelContent: "pos"
    labelStyle:
      attributes: ["colour","selected"]
      modelChanged: "labelStyle"
    icon:
      attributes: ["name","colour"]
      modelChanged: "icon"
    position:
      lat: "lat"
      lng: "lng"
    visible:
      attribute: "selected"
      modelChanged: "visible"

  labelStyle: ({colour:colour,selected:selected}={}) =>
    "background-color": colour
    color: @textColour colour

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

  visible: ({selected:selected}={}) =>
    selected is true

class FellRace.Views.CheckpointMarkers extends MapStick.OverlayCollection
  itemView: FellRace.Views.CheckpointMarker


class FellRace.Views.Checkpoint extends Backbone.Marionette.ItemView
  template: 'checkpoints/list_item'
  tagName: "li"
  className: "checkpoint"

  events:
    "click a": "goTo"

  bindings:
    ':el':
      observe: ["lat","lng"]
      visible: "latAndLng"
      attributes: [
        name: "class"
        observe: "fixed"
        onGet: "getClass"
      ]
    'span.symbol':
      observe: "name"
      updateMethod: 'text'
      onGet: 'setSymbol'
    'a.name': "name"
    'span.gridref': "gridref"

  initialize: (options) =>
    @_race_slug = options.race_slug

  onRender: =>
    @stickit()

  setSymbol: (name) =>
    code = "\u25CB"
    if name is "Start"
      code = "\u25B3"
    else if name is "Finish"
      code = "\u25CE"
    code

  getClass: (val) =>
    if val
      @model.get("name").toLowerCase()

  goTo: =>
    _fellrace.moveMapTo @model

  latAndLng: ([lat,lng]=[]) =>
    lat and lng

class FellRace.Views.CheckpointsList extends Backbone.Marionette.CollectionView
  itemView: FellRace.Views.Checkpoint
