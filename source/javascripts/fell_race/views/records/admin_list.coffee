class FellRace.Views.AdminRecord extends FellRace.View
  template: 'records/admin_list_item'
  tagName: "li"
  className: "record"

  events:
    'click a.delete': "delete"

  bindings:
    'span.label': 'label'
    'span.time':
      observe: 'elapsed_time'
      onGet: 'simplestTime'
      onSet: "seconds"
    'span.name': 'holder'
    'span.year': 'year'

  onRender: () =>
    @$el.find('.editable').editable()
    @stickit()

  simplestTime: (seconds) =>
    seconds?.toSimplestTime()

  seconds: (string) =>
    string?.toSeconds()

  delete: (e) =>
    e.stopPropagation() if e
    @model.destroy()

class FellRace.Views.AddFirstRecord extends FellRace.View
  template: 'records/empty'
  tagName: "li"
  className: "note"

class FellRace.Views.AdminRecordsList extends FellRace.CollectionView
  itemView: FellRace.Views.AdminRecord
  emptyView: FellRace.Views.AddFirstRecord
