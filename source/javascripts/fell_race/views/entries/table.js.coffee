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

    "a.forename":
      observe: ["competitor_forename","competitor_middlename"]
      onGet: "name"
      attributes: [
        {
          observe: "id"
          name: "href"
          onGet: "competitorUrl"
        }
      ]
    "a.surname":
      observe: "competitor_surname"
      attributes: [
        {
          observe: "id"
          name: "href"
          onGet: "competitorUrl"
        }
      ]
    "span.cat": "category"

  onRender: =>
    @stickit()

  competitorUrl: (id) ->
    "/runners/#{id}"

  name: ([fore,middle]=[]) ->
    if middle then "#{fore} #{middle}" else fore


class FellRace.Views.EntriesTable extends Backbone.Marionette.CompositeView
  itemView: FellRace.Views.EntryRow
  template: "entries/table"
  itemViewContainer: "tbody"
