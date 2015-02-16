class FellRace.Views.Record extends Backbone.Marionette.ItemView
  template: 'records/list_item'
  tagName: "li"
  className: "record"

  bindings:
    'span.label': 'label'
    'span.time': 'elapsed_time'
    'span.name': 'holder'
    'span.year': 'year'

  onRender: () =>
    @stickit()

class FellRace.Views.RecordsList extends Backbone.Marionette.CollectionView
  itemView: FellRace.Views.Record
