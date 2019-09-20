class FellRace.Views.AdminCheckpoint extends FellRace.View
  template: 'checkpoints/admin_list_item'
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
    'span.name': "name"
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
    @model.set pos: @$el.index(),
      persistChange: true

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


class FellRace.Views.AddFirstCheckpoint extends FellRace.View
  template: 'checkpoints/empty'
  tagName: "li"
  className: "note"


class FellRace.Views.AdminCheckpointsList extends FellRace.CollectionView
  childView: FellRace.Views.AdminCheckpoint
  emptyView: FellRace.Views.AddFirstCheckpoint
  selectable: true
  sortable: true
  events:
    "sorting": "makeStatic"
    "sorted": "resort"

  onRender: () =>
    @collection.on "routable", @showRouter
    @collection.on "unroutable", @hideRouter
    @collection.checkRoutability()
    @_sortable = $.sortable @el,
      placeholder: '<li class="checkpoint placeholder" />'
      selector: 'li'
      handle: 'span.symbol'
    @collection.on "add", @updateSortable

  updateSortable: () =>
    @_sortable.refresh()

  resort: (dragging, outcome) =>
    @$el.children().each (i, element) =>
      $(element).trigger "reordered"
    @makeEditable()

  makeStatic: () =>
    @$el.find('.editable').removeAttr('contentEditable')

  makeEditable: () =>
    @$el.find('.editable').editable()

  showRouter: () =>
    $('.router').show()

  hideRouter: () =>
    $('.router').hide()
