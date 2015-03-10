class FellRace.Views.RaceHistory extends Backbone.Marionette.ItemView
  template: 'race_publications/history'
  className: "race"

  bindings:
    ".race_name": "name"
    "a.close, a.race_name":
      attributes: [
        name: "href"
        observe: "slug"
        onGet: "racePublicationUrl"
      ]

  onRender: =>
    @stickit()
    unless @model.best_performances
      @model.best_performances = new FellRace.Collections.Performances
      @model.best_performances.url = "#{@model.url()}/performances/best"
      @model.best_performances.fetch()
    table = new FellRace.Views.HistoryTable
      collection: @model.best_performances
      el: @$el.find("table.history")
    table.render()

  racePublicationUrl: (slug) =>
    "/races/#{slug}"
