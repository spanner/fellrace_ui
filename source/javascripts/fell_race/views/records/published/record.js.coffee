class FellRace.Views.PublishedRecord extends Backbone.Marionette.ItemView
  template: 'records/published/list_item'
  model: FellRace.Models.Record
  tagName: "li"
  className: "record"

  bindings:
    'span.label':
      observe: 'label'

    'span.time':
      observe: 'elapsed_time'

    'span.name':
      observe: 'holder'

    'span.year':
      observe: 'year'

  onRender: () =>
    @stickit()
