class FellRace.Views.RaceHistory extends FellRace.View
  template: 'race_publications/history'
  className: "race"

  events:
    "click a.compact": "compact"
    "click a.full": "full"

  bindings:
    ".race_name": "name"
    "a.compact, span.all_runs":
      observe: "compact"
      visible: "untrue"

    "a.full, span.all_runners":
      observe: "compact"
      visible: true

    "span.performances_count": "performances_count"
    "span.competitors_count": "competitors_count"

    "span.since":
      observe: "earliest_year"
      onGet: (year) ->
        "since #{year}" if year

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
    unless @model.performances
      @_comp_count = 0
      @_earliest_date = moment()
      @model.performances = new FellRace.Collections.Performances
      @model.performances.url = "#{@model.url()}/performances/best"
      @model.performances.fetch().done =>
        @model.performances.forEach (model) =>
          model.set p_pos: @model.performances.indexOf(model) + 1
          date = moment(model.get("date"), "YYYY-MM-DD")
          if date < @_earliest_date
            @_earliest_date = date
          unless @model.performances.filter((p) -> p.get("competitor_id") is model.get("competitor_id") and p.get("p_pos")).length > 1
            model.set c_pos: @_comp_count += 1
        @model.set
          competitors_count: @_comp_count
          performances_count: @model.performances.length
          earliest_year: @_earliest_date.year()

  onRender: =>
    @stickit()

    @_filter = new FellRace.Views.CollectionFilter
      collection: @model.performances
      el: @$el.find('input.filter')
    @_filter.render()

    @table_el = @$el.find("table.history tbody")
    table = new FellRace.Views.HistoryTable
      collection: @model.performances
      el: @table_el
    table.render()
    # hacky shortcut, this, to bring down any wait spinners we have scattered around. Do it properly!
    _fr.vent.trigger 'loaded'

  racePublicationUrl: (slug) =>
    "/races/#{slug}"

  compact: =>
    @model.set compact: true

  full: =>
    @model.set compact: false

  untrue: (val) ->
    !val