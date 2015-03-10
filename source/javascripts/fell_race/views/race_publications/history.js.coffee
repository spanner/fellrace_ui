class FellRace.Views.RaceHistory extends Backbone.Marionette.ItemView
  template: 'race_publications/history'
  className: "race"

  events:
    "click a.compact": "compact"
    "click a.full": "full"

  bindings:
    ".race_name": "name"
    "a.compact":
      observe: "compact"
      visible: "untrue"

    "a.full":
      observe: "compact"
      visible: true

    "table.history":
      attributes: [
        observe: "compact"
        name: "class"
        onGet: (compact) ->
          "compact" if compact
      ]

    "a.close, a.race_name":
      attributes: [
        name: "href"
        observe: "slug"
        onGet: "racePublicationUrl"
      ]

  initialize: ->
    @_comp_count = 0
    unless @model.performances
      @model.performances = new FellRace.Collections.Performances
      @model.performances.url = "#{@model.url()}/performances/best"
      @model.performances.fetch().done =>
        @model.performances.forEach (model) =>
          model.set p_pos: @model.performances.indexOf(model) + 1
          unless @model.performances.filter((p) -> p.get("competitor_id") is model.get("competitor_id") and p.get("p_pos")).length > 1
            model.set c_pos: @_comp_count += 1

  onRender: =>
    @stickit()
    @table_el = @$el.find("table.history")

    table = new FellRace.Views.HistoryTable
      collection: @model.performances
      el: @table_el
    table.render()

  racePublicationUrl: (slug) =>
    "/races/#{slug}"

  compact: =>
    @model.set compact: true

  full: =>
    @model.set compact: false

  untrue: (val) ->
    !val