class FellRace.Views.AdminEntryRow extends Backbone.Marionette.ItemView
  template: "entries/admin_row"
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



class FellRace.Views.AdminEntriesTable extends Backbone.Marionette.CompositeView
  itemView: FellRace.Views.AdminEntryRow
  template: "entries/admin_table"
  tagName: "table"
  itemViewContainer: "tbody"
