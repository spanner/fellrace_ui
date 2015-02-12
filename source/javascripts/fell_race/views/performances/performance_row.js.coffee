class FellRace.Views.PerformanceRow extends Backbone.Marionette.ItemView
  template: 'performances/row'
  className: "performance"
  tagName: "tr"

  bindings:
    ":el":
      attributes: [
        {
          name: 'class'
          observe: 'odd_or_even'
        }
      ]
    "span.time":
      observe: "time"
      onGet: "time"
    "span.pos":
      observe: "pos"
    "span.total":
      observe: "pos"
      onGet: "total"

  instanceBindings:
    ".date": "date"
    "a.time":
      attributes: [
        {
          name: 'href',
          observe: 'name'
          onGet: "resultsUrl"
        }
      ]

  raceBindings:
    "span.race_name": "name"

  initialize: ->
    @_instance = new FellRace.Models.Instance @model.get("instance")
    @_race = new FellRace.Models.Race @_instance.get("race")

  onRender: =>
    @stickit()
    @stickit(@_instance, @instanceBindings)
    @stickit(@_race, @raceBindings)

  resultsUrl: =>
    @_instance.resultsUrl()

  position: (pos) =>
    if total = @model.getInstancePerformancesCount()
      pos = "#{pos}<span class='total'>/#{total}<span>"
    pos

  eventUrl: =>
    @model.eventUrl()

  total: =>
    if total = @model.getInstancePerformancesCount()
      "/#{total}"

  time: (val) =>
    time = val.split(":")
    if time[0] isnt "0"
      val
    else
      [time[1], time[2]].join(":")
