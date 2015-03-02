class FellRace.Views.InstanceResults extends Backbone.Marionette.ItemView
  template: 'instances/results'

  bindings:
    ".race_name": "race_name"
    ".instance_name": "name"
    "a.race_name, a.close":
      attributes: [
        name: "href"
        observe: "race_slug"
        onGet: (race_slug) =>
          "/races/#{race_slug}"
      ]
    "p.download":
      observe: "file_name"
      visible: "notCSV"
    "a.file_icon":
      observe: "file_name"
      attributes: [
        name: "href"
        observe: "file"
      ,
        name: "class"
        observe: "file_name"
        onGet: "fileClass"
      ]

    "table#results_table":
      attributes: [
        observe: "show_splits"
        name: "class"
        onGet: (show) =>
          "simple" unless show
      ]

    "a.show_splits":
      observe: ["checkpoints","show_splits"]
      visible: ([cps,show]=[]) =>
        cps and cps.length and !show
      attributes: [
        observe: ["race_slug","name","competitor_id"]
        name: "href"
        onGet: ([slug,name,comp_id]=[]) =>
          if comp_id
            url = "/runners/#{comp_id}"
          else
            url = "/races"
          url = "#{url}/#{slug}/#{name}/splits"
      ]

    "a.hide_splits":
      observe: "show_splits"
      visible: true
      attributes: [
        observe: ["race_slug","name","competitor_id"]
        name: "href"
        onGet: ([slug,name,comp_id]=[]) =>
          if comp_id
            url = "/runners/#{comp_id}"
          else
            url = "/races"
          url = "#{url}/#{slug}/#{name}"
      ]

  initialize: ({competitor:@_competitor}={}) ->
    if @_competitor
      @model.set competitor_id: @_competitor.id
    #

  onRender: =>
    @stickit()
    @_performances = @model.performances
    if @_performances.length
      if @_competitor
        @_performances.findWhere(competitor_id: @_competitor.id)?.set current: true

    # Results.search.show new Results.Views.PerformancesFilter
    #   collection: @_performances

    table = new FellRace.Views.ResultsTable
      collection: @_performances
      model: @model
      el: @$el.find("#results_table")

    table.render()

    # if d3? and splits
    #   chart = new FellRace.Views.PerformancesChart
    #     model: @model
    #     collection: @_performances
    #   chart.render()


  fileUrl: (path) =>
    "http://api.fr.dev#{path}"
  
  fileClass: (filename) =>
    if filename
      filename.split('.').pop()

  notCSV: (filename) =>
    @fileClass(filename) isnt "csv"