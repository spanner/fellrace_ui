class Home.Views.PerformanceRow extends Backbone.Marionette.ItemView
  template: 'performances/row'
  className: "performance"
  tagName: "tr"

  bindings:
    ".date":
      observe: "instance"
      onGet: "date"
    ".race_name":
      observe: "race"
      onGet: "getRaceName"
      attributes: [
        {
          name: 'href',
          observe: 'race'
          onGet: "eventUrl"
        }
      ]
    ".time":
      observe: "time"
      attributes: [
        {
          name: 'href',
          observe: 'instance'
          onGet: "resultsUrl"
        }
      ]
    ".pos":
      observe: "pos"
      onGet: "position"

  resultsUrl: () =>
    @model.instanceUrl()

  onRender: =>
    @stickit()

  getRaceName: =>
    @model.getRaceName()

  position: (pos) =>
    if total = @model.getInstancePerformancesCount()
      pos = "#{pos}/#{total}"
    pos

  eventUrl: =>
    @model.eventUrl()

  date: (instance) =>
    date = new Date(instance.started_at)
    "#{date.getDate()}-#{date.getMonth() + 1}-#{date.getFullYear()}"