class FellRace.Views.PublishedCheckpoint extends Backbone.Marionette.ItemView
  template: 'checkpoints/published/list_item'
  tagName: "li"
  className: "checkpoint"

  events:
    "click a": "goTo"

  bindings:
    ':el':
      attributes: [
        {
          name: "class"
          observe: "fixed"
          onGet: "getClass"
        }
      ]
    'span.symbol':
      observe: "name"
      updateMethod: 'text'
      onGet: 'setSymbol'
    '.name': "name"
    'span.gridref': "gridref"

  onRender: =>
    @stickit()

  setName: (vals) =>
    name = vals[0] || ""
    unless vals[2]
      name = "#{vals[1]}: #{name}"
    name

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
