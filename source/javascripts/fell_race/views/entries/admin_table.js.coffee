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

    "a.forename":
      observe: ["competitor_forename","competitor_middlename"]
      onGet: "name"
      attributes: [
        {
          observe: "competitor_id"
          name: "href"
          onGet: "competitorUrl"
        }
      ]
    "a.surname":
      observe: "competitor_surname"
      attributes: [
        {
          observe: "competitor_id"
          name: "href"
          onGet: "competitorUrl"
        }
      ]
    "span.cat": "category"

    "input.paid": "paid"

    "input.accepted":
      observe: "accepted"
      attributes: [
        observe: "paid"
        name: "disabled"
      ]

  onRender: =>
    @stickit()

  competitorUrl: (id) =>
    "/runners/#{id}"

  name: ([fore,middle]=[]) ->
    if middle then "#{fore} #{middle}" else fore

class FellRace.Views.AdminEntriesTable extends Backbone.Marionette.CompositeView
  itemView: FellRace.Views.AdminEntryRow
  template: "entries/admin_table"
  itemViewContainer: "tbody"
