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

    "a.name":
      attributes: [
        {
          observe: "competitor_id"
          name: "href"
          onGet: "competitorUrl"
        }
      ]
    "span.fore": "forename"
    "span.middle": "middlename"
    "span.sur": "surname"
    "td.cat": "category"
    "td.club": "club_name"

  onRender: =>
    @stickit()

  competitorUrl: (id) ->
    "/runners/#{id}"

  clubUrl: (id) ->
    "/clubs/#{id}" if id

class FellRace.Views.EntriesTable extends Backbone.Marionette.CompositeView
  itemView: FellRace.Views.EntryRow
  template: "entries/table"
  itemViewContainer: "tbody"
