class FellRace.Views.Checkpoint extends FellRace.View
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
    'a.name': 
      observe: "name"
      attributes: [
        name: "href"
        observe: "slug"
        onGet: "setHref"
      ]
    'span.gridref': "gridref"

  initialize: (options) =>
    @_race_slug = options.race_slug

  onRender: =>
    @stickit()

  setName: (vals) =>
    name = vals[0] || ""
    unless vals[2]
      name = "#{vals[1]}: #{name}"
    name
  
  setHref: (slug) =>
    href = "/races/#{@_race_slug}/checkpoints/#{slug}"

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
    @model.trigger "go_to"

  latAndLng: ([lat,lng]=[]) =>
    lat and lng

class FellRace.Views.CheckpointsList extends FellRace.CollectionView
  itemView: FellRace.Views.Checkpoint

  itemViewOptions: () =>
    race_slug: @_race_slug

  initialize: (options) =>
    @_race_slug = options.race_slug
