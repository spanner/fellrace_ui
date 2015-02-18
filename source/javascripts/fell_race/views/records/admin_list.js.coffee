class FellRace.Views.AdminRecord extends Backbone.Marionette.ItemView
  template: 'records/admin_list_item'
  tagName: "li"
  className: "record"

  events:
    'click a.delete': "delete"

  bindings:
    'span.label': 'label'
    'span.time':
      observe: 'elapsed_time'
      onGet: 'secondsToString'
      onSet: "stringToSeconds"
    'span.name': 'holder'
    'span.year': 'year'

  onRender: () =>
    @$el.find('.editable').editable()
    @stickit()

  secondsToString: (seconds) =>
    _fellrace.secondsToString seconds

  stringToSeconds: (string) =>
    _fellrace.stringToSeconds string

  delete: (e) =>
    e.stopPropagation() if e
    @model.destroy()

class FellRace.Views.AddFirstRecord extends Backbone.Marionette.ItemView
  template: 'records/empty'
  tagName: "li"
  className: "note"

class FellRace.Views.AdminRecordsList extends Backbone.Marionette.CollectionView
  itemView: FellRace.Views.AdminRecord
  emptyView: FellRace.Views.AddFirstRecord
