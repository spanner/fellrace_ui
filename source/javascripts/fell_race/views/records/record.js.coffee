class FellRace.Views.Record extends Backbone.Marionette.ItemView
  template: 'records/list_item'
  model: FellRace.Models.Record
  tagName: "li"
  className: "record"
  modelEvents:
    destroy: "close"
  events:
    'click a.delete': "delete"
  bindings:
    'span.label':
      observe: 'label'
      events: ['blur']
    'span.time':
      observe: 'elapsed_time'
      events: ['blur']
    'span.name':
      observe: 'holder'
      events: ['blur']
    'span.year':
      observe: 'year'
      events: ['blur']

  onRender: () =>
    @model.save() if @model.isNew()
    @$el.find('.editable').editable()
    @stickit()

  delete: (e) =>
    e.preventDefault() if e
    @model.destroy()
