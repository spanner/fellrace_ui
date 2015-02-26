class FellRace.Views.EntryRow extends Backbone.Marionette.ItemView
  template: "entries/row"
  className: "entry"
  tagName: "tr"

  bindings:
    ":el":
      attributes: [
        {
          name: 'class'
          observe: 'odd_or_even'
        }
      ]

  competitorBindings:
    "a.forename":
      observe: "forename"
      attributes: [
        {
          observe: "id"
          name: "href"
          onGet: "competitorUrl"
        }
      ]
    "a.surname":
      observe: "surname"
      attributes: [
        {
          observe: "id"
          name: "href"
          onGet: "competitorUrl"
        }
      ]

  onRender: =>
    @stickit()
    @stickit(@model.competitor, @competitorBindings)

  competitorUrl: (id) =>
    "/runners/#{id}"



class FellRace.Views.EntriesTable extends Backbone.Marionette.CompositeView
  itemView: FellRace.Views.EntryRow
  template: "entries/table"
  tagName: "table"
  itemViewContainer: "tbody"
