class FellRace.Views.InstanceResults extends Backbone.Marionette.ItemView
  template: 'instances/published/results'

  bindings:
    "a.instance_name":
      observe: "name"
      attributes: [
        {
          name: "href"
          onGet: "instanceUrl"
        }
      ]

  race_bindings:
    "a.race_name":
      observe: "name"
      attributes: [
        name: "href"
        observe: "slug"
        onGet: "raceUrl"
      ]

  initialize: ({competitor:@_competitor}) ->
    @_race = @model.race
    @_performances = @model.performances

  onRender: =>
    @stickit()
    @_race.fetch()
    @stickit @_race, @race_bindings
    
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
      competitor: @competitor

    table.render()


      # row: FellRace.Views.ResultRow

    # if d3? and splits
    #   chart = new FellRace.Views.PerformancesChart
    #     model: @model
    #     collection: @_performances
    #   chart.render()

  raceUrl: (slug) =>
    "/races/#{slug}"

  instanceUrl: (name) =>
    "/races/#{@_race.get("slug")}/#{name}"
