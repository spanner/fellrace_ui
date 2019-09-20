class FellRace.Views.Record extends FellRace.View
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

class FellRace.Views.RecordsList extends FellRace.CollectionView
  childView: FellRace.Views.Record
