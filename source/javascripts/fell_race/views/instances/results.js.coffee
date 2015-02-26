class FellRace.Views.InstanceResults extends Backbone.Marionette.ItemView
  template: 'instances/results'

  bindings:
    ".race_name":
      observe: "race_name"
      attributes: [
        name: "href"
        observe: "race_slug"
        onGet: (race_slug) =>
          "/races/#{race_slug}"
      ]
    ".instance_name":
      observe: "name"
      attributes: [
        name: "href"
        observe: ["race_slug","name"]
        onGet: ([race_slug,name]=[]) =>
          "/races/#{race_slug}/#{name}"
      ]

  initialize: ({competitor:competitor}={}) ->
    @_performances = @model.performances
    if competitor
      @_performances.findWhere(competitor_id: competitor.id)?.set current: true

  onRender: =>
    @stickit()
    
    @_checkpoints = new FellRace.Collections.Checkpoints @model.get("checkpoints"), instance: @model

    splits = @model.has("checkpoints") and @model.get("checkpoints").length > 0

    grid_columns = [
      name: 'position'
      sortable: true
      cell: "string"
      editable: false
    ,
      name: 'name'
      sortable: true
      cell: FellRace.Views.NameCell
      editable: false
    ,
      name: 'club'
      sortable: true
      cell: "string"
      editable: false
    ,
      name: 'cat'
      sortable: true
      cell: "string"
      editable: false
    ,
      name: 'time'
      sortable: true
      cell: FellRace.Views.TimeCell
      editable: false
      sortValue: (model, sortkey) =>
        time = model.get sortkey
        if time is 0 or time is null then 99999999 else time
    ]

    select_col = {
      name: ""
      cell: "select-row"
      headerCell: "select-all"
    }

    if splits
      grid_columns.splice(0,0,select_col)
    else
      $('.chart_select').hide()

    checkpoints = _.without(@_checkpoints.pluck('name'), 'Start')

    _.each checkpoints, (name) ->
      grid_columns.push
        name: name
        sortable: true
        cell: Backgrid.SplitCell
        sortValue: (model, sortkey) =>
          if model.has sortkey
            model.get(sortkey).split_position
          else
            99999999
        editable: false

    # Results.search.show new Results.Views.PerformancesFilter
    #   collection: @_performances

    table = new FellRace.Views.ResultsTable
      collection: @_performances
      columns: grid_columns
      row: FellRace.Views.ResultRow
      el: @$el.find("#results_table")

    table.render()


      # row: FellRace.Views.ResultRow

    # if d3? and splits
    #   chart = new FellRace.Views.PerformancesChart
    #     model: @model
    #     collection: @_performances
    #   chart.render()
