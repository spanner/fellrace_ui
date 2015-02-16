class FellRace.Views.AdminCheckpointsList extends Backbone.Marionette.CollectionView
  itemView: FellRace.Views.AdminCheckpoint
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
