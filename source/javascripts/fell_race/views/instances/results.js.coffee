class FellRace.Views.InstanceResults extends Backbone.Marionette.ItemView
  template: 'instances/results'

  bindings:
    ".race_name": "race_name"
    ".instance_name": "name"
    "p.summary":
      observe: "summary"
      updateView: true
      visible: true
    "a.race_name":
      attributes: [
        name: "href"
        observe: "race_slug"
        onGet: (race_slug) ->
          "/races/#{race_slug}"
      ]
    "a.close":
      attributes: [
        name: "href"
        observe: ["race_slug","competitor_id"]
        onGet: ([slug,id]=[]) ->
          if id then "/runners/#{id}" else "/races/#{slug}"
      ]

    "a.edit":
      observe: "permissions"
      onGet: ({can_edit:can_edit}={}) -> can_edit
      visible: true
      attributes: [
        observe: ["race_slug","name"]
        name: "href"
        onGet: "adminUrl"
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
      observe: "has_results"
      visible: true
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
          stem = if comp_id then "/runners/#{comp_id}" else "/races"
          url = "#{stem}/#{slug}/#{name}/splits"
      ]

    "a.hide_splits":
      observe: "show_splits"
      visible: true
      attributes: [
        observe: ["race_slug","name","competitor_id"]
        name: "href"
        onGet: ([slug,name,comp_id]=[]) =>
          stem = if comp_id then "/runners/#{comp_id}" else "/races"
          url = "#{stem}/#{slug}/#{name}"
      ]

  initialize: ({competitor:@_competitor}={}) ->
    @model.set(competitor_id: @_competitor.id) if @_competitor

  onRender: =>
    @stickit()
    @_performances = @model.performances
    if @_performances.length
      if @_competitor
        @_performances.findWhere(competitor_id: @_competitor.id)?.set current: true

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

  adminUrl: ([slug,name]) =>
    "/admin/races/#{slug}/#{name}"
