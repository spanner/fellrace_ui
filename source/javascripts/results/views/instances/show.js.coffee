class Results.Views.Instance extends Backbone.Marionette.ItemView
  template: 'instances/show'

  onRender: =>
    @_checkpoints = new Results.Collections.Checkpoints @model.get("checkpoints"), instance: @model
    @_performances = new Results.Collections.Performances @model.get("performances"), instance: @model

    splits = @model.has("checkpoints") and @model.get("checkpoints").length > 0

    grid_columns = [
      name: 'position'
      sortable: true
      cell: "string"
      editable: false
    ,
      name: 'name'
      sortable: true
      cell: Results.Views.NameCell
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
      cell: "time"
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

    Results.search.show new Results.Views.PerformancesFilter
      collection: @_performances

    Results.table.show new Results.Views.PerformancesTable
      collection: @_performances
      columns: grid_columns
      row: Results.Views.PerformanceRow

    if d3? and splits
      chart = new Results.Views.PerformancesChart
        model: @model
        collection: @_performances
      chart.render()
