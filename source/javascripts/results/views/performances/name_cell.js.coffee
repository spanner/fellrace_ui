class Results.Views.NameCell extends Backgrid.Cell
  template: JST["performances/name_cell"]
  className: "runner"

  events:
    "click .competitor": "goToCompetitor"

  render: =>
    @$el.empty()
    @$el.html @template(@model)
    @delegateEvents()
    @
