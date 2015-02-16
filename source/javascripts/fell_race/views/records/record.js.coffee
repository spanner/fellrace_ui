class FellRace.Views.Record extends Backbone.Marionette.ItemView
  template: 'records/list_item'
  model: FellRace.Models.Record
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
    _fellrace.secondsToTime seconds

  stringToSeconds: (string) =>
    moment.duration(string).asSeconds()

  delete: (e) =>
    e.stopPropagation() if e
    @model.destroy()
