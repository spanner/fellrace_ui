class FellRace.Views.ResultsPreview extends FellRace.View
  template: 'instances/results_preview'

  initialize: ({competitor:@_competitor}) ->
    @_performances = @model.performances

  onRender: =>
    # console.log @model
    # @_checkpoints = new FellRace.Collections.Checkpoints @model.get("checkpoints"), instance: @model
    # grid_columns = [
    #   name: 'position'
    #   sortable: true
    #   cell: "string"
    #   editable: false
    # ,
    #   name: 'name'
    #   sortable: true
    #   cell: FellRace.Views.NameCell
    #   editable: false
    # ,
    #   name: 'club'
    #   sortable: true
    #   cell: "string"
    #   editable: false
    # ,
    #   name: 'cat'
    #   sortable: true
    #   cell: "string"
    #   editable: false
    # ,
    #   name: 'time'
    #   sortable: true
    #   cell: FellRace.Views.TimeCell
    #   editable: false
    #   sortValue: (model, sortkey) =>
    #     time = model.get sortkey
    #     if time is 0 or time is null then 99999999 else time
    # ]
    #
    # checkpoints = _.without(@_checkpoints.pluck('name'), 'Start')


    # table = new FellRace.Views.ResultsTable
    #   collection: @_performances
    #   row: FellRace.Views.ResultRow
    #   el: @$el.find("#results_table")
    #
    # table.render()
