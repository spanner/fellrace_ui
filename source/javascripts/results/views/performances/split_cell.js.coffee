class Backgrid.SplitCell extends Backgrid.Cell
  template: JST["performances/split_cell"]
  className: "checkpoint"

  render: =>
    @$el.empty()
    @$el.html @template(@model.get("checkpoints")?[@column.get("name")])
    @delegateEvents()
    @
