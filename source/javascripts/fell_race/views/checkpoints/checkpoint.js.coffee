class FellRace.Views.Checkpoint extends Backbone.Marionette.ItemView
  template: 'checkpoints/list_item'
  tagName: "li"
  className: "checkpoint"

  events:
    "click a.delete": "delete"
    "click a.place": "place"
    'reordered': 'sorted'

  modelEvents:
    destroy: "close"

  bindings:
    'span.symbol':
      observe: "name"
      updateMethod: 'text'
      onGet: 'setSymbol'
    'span.name':
      observe: "name"
      updateMethod: 'html'
      events: ['blur']
    'span.gridref': "gridref"
    'span.pos':
      observe: "pos"
      onGet: 'setPrefix'
    'a.place':
      observe: "placed"
      updateView: false
      visible: (val, options) ->
        !val

  onRender: =>
    @$el.attr('id', "cp_#{@model.get('id')}")
    if @model.get('fixed')
      @$el.find('a.delete').remove()
      @$el.find('span.unfixed').removeClass "unfixed"
      @$el.find('span.name').removeClass('editable')
    @$el.find('.editable').editable()
    @stickit()

  delete: (e) =>
    e.preventDefault() if e
    @model.destroy()

  sorted: (e) =>
    @model.set
      pos: @$el.index()

  place: =>
    @model.trigger "draw"

  setPrefix: (pos) =>
    unless @model.get "fixed"
      "#{pos}:"
    else
      ""

  setSymbol: (name) =>
    code = "\u25CB"
    if name is "Start"
      code = "\u25B3"
    else if name is "Finish"
      code = "\u25CE"
    code

  onClose: =>
    @marker?.close()
