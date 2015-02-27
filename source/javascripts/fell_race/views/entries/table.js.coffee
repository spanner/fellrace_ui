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

    "span.cat": "category"
    "a.club":
      observe: "club_name"
      attributes: [
        observe: "club_id"
        name: "href"
        onGet: "clubUrl"
      ]

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
